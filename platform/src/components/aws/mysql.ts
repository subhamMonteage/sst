import {
  all,
  ComponentResourceOptions,
  interpolate,
  jsonStringify,
  Output,
  output,
} from "@pulumi/pulumi";
import { Component, Transform, transform } from "../component";
import { Link } from "../link";
import { Input } from "../input.js";
import { iam, rds, secretsmanager } from "@pulumi/aws";
import { RandomPassword } from "@pulumi/random";
import { Vpc } from "./vpc";
import { Vpc as VpcV1 } from "./vpc-v1";
import { VisibleError } from "../error";
import { SizeGbTb, toGBs } from "../size";
import { DevCommand } from "../experimental/dev-command.js";
import { RdsRoleLookup } from "./providers/rds-role-lookup";

export interface MysqlArgs {
  version?: Input<string>;
  username?: Input<string>;
  password?: Input<string>;
  database?: Input<string>;
  instance?: Input<string>;
  storage?: Input<SizeGbTb>;
  proxy?: Input<
    | boolean
    | {
        credentials?: Input<
          Input<{
            username: Input<string>;
            password: Input<string>;
          }>[]
        >;
      }
  >;
  multiAz?: Input<boolean>;
  replicas?: Input<number>;
  vpc:
    | Vpc
    | Input<{
        subnets: Input<Input<string>[]>;
      }>;
  dev?: {
    host?: Input<string>;
    port?: Input<number>;
    database?: Input<string>;
    username?: Input<string>;
    password?: Input<string>;
  };
  transform?: {
    subnetGroup?: Transform<rds.SubnetGroupArgs>;
    parameterGroup?: Transform<rds.ParameterGroupArgs>;
    instance?: Transform<rds.InstanceArgs>;
    proxy?: Transform<rds.ProxyArgs>;
  };
}

export interface MysqlGetArgs {
  id: Input<string>;
  proxyId?: Input<string>;
}

interface MysqlRef {
  ref: boolean;
  id: Input<string>;
  proxyId?: Input<string>;
}

export class Mysql extends Component implements Link.Linkable {
  private instance?: rds.Instance;
  private _password?: Output<string>;
  private proxy?: Output<rds.Proxy | undefined>;
  private dev?: {
    enabled: boolean;
    host: Output<string>;
    port: Output<number>;
    username: Output<string>;
    password: Output<string>;
    database: Output<string>;
  };

  constructor(
    name: string,
    args: MysqlArgs,
    opts?: ComponentResourceOptions,
  ) {
    super(__pulumiType, name, args, opts);
    const _version = 1;
    const self = this;

    if (args && "ref" in args) {
      const ref = reference();
      this.instance = ref.instance;
      this._password = ref.password;
      this.proxy = output(ref.proxy);
      return;
    }

    registerVersion();
    const multiAz = output(args.multiAz).apply((v) => v ?? false);
    const engineVersion = output(args.version).apply((v) => v ?? "8.0.26");
    const instanceType = output(args.instance).apply((v) => v ?? "t4g.micro");
    const username = output(args.username).apply((v) => v ?? "admin");
    const storage = normalizeStorage();
    const dbName = output(args.database).apply(
      (v) => v ?? $app.name.replaceAll("-", "_"),
    );
    const vpc = normalizeVpc();

    const dev = registerDev();
    if (dev?.enabled) {
      this.dev = dev;
      return;
    }

    const password = createPassword();
    const secret = createSecret();
    const subnetGroup = createSubnetGroup();
    const parameterGroup = createParameterGroup();
    const instance = createInstance();
    createReplicas();
    const proxy = createProxy();

    this.instance = instance;
    this._password = password;
    this.proxy = proxy;

    function reference() {
      const ref = args as unknown as MysqlRef;
      const instance = rds.Instance.get(`${name}Instance`, ref.id, undefined, {
        parent: self,
      });

      const input = instance.tags.apply((tags) => {
        registerVersion(
          tags?.["sst:component-version"]
            ? parseInt(tags["sst:component-version"])
            : undefined,
        );

        return {
          proxyId: output(ref.proxyId),
          passwordTag: tags?.["sst:lookup:password"],
        };
      });

      const proxy = input.proxyId.apply((proxyId) =>
        proxyId
          ? rds.Proxy.get(`${name}Proxy`, proxyId, undefined, {
              parent: self,
            })
          : undefined,
      );

      const password = input.passwordTag.apply((passwordTag) => {
        if (!passwordTag)
          throw new VisibleError(
            `Failed to get password for Mysql ${name}.`,
          );

        const secret = secretsmanager.getSecretVersionOutput(
          { secretId: passwordTag },
          { parent: self },
        );
        return $jsonParse(secret.secretString).apply(
          (v) => v.password as string,
        );
      });

      return { instance, proxy, password };
    }

    function registerVersion(overrideVersion?: number) {
      self.registerVersion({
        new: _version,
        old: overrideVersion ?? $cli.state.version[name],
        message: [
          `This component has been renamed. Please change:\n`,
          `"sst.aws.Mysql" to "sst.aws.Mysql.v${$cli.state.version[name]}"\n`,
          `Learn more https://sst.dev/docs/components/#versioning`,
        ].join("\n"),
      });
    }

    function normalizeStorage() {
      return output(args.storage ?? "20 GB").apply((v) => {
        const size = toGBs(v);
        if (size < 20) {
          throw new VisibleError(
            `Storage must be at least 20 GB for the ${name} Mysql database.`,
          );
        }
        if (size > 65536) {
          throw new VisibleError(
            `Storage cannot be greater than 65536 GB (64 TB) for the ${name} Mysql database.`,
          );
        }
        return size;
      });
    }

    function normalizeVpc() {
      if (args.vpc instanceof VpcV1) {
        throw new VisibleError(
          `You are using the "Vpc.v1" component. Please migrate to the latest "Vpc" component.`,
        );
      }

      if (args.vpc instanceof Vpc) {
        return {
          subnets: args.vpc.privateSubnets,
        };
      }

      return output(args.vpc);
    }

    function registerDev() {
      if (!args.dev) return undefined;

      if (
        $dev &&
        args.dev.password === undefined &&
        args.password === undefined
      ) {
        throw new VisibleError(
          `You must provide the password to connect to your locally running Mysql database either by setting the "dev.password" or by setting the top-level "password" property.`,
        );
      }

      const dev = {
        enabled: $dev,
        host: output(args.dev.host ?? "localhost"),
        port: output(args.dev.port ?? 3306),
        username: args.dev.username ? output(args.dev.username) : username,
        password: output(args.dev.password ?? args.password ?? ""),
        database: args.dev.database ? output(args.dev.database) : dbName,
      };

      new DevCommand(`${name}Dev`, {
        dev: {
          title: name,
          autostart: true,
          command: `sst print-and-not-quit`,
        },
        environment: {
          SST_DEV_COMMAND_MESSAGE: interpolate`Make sure your local MySQL server is using:

  username: "${dev.username}"
  password: "${dev.password}"
  database: "${dev.database}"

Listening on "${dev.host}:${dev.port}"...`,
        },
      });

      return dev;
    }

    function createPassword() {
      return args.password
        ? output(args.password)
        : new RandomPassword(
            `${name}Password`,
            {
              length: 32,
              special: false,
            },
            { parent: self },
          ).result;
    }

    function createSubnetGroup() {
      return new rds.SubnetGroup(
        ...transform(
          args.transform?.subnetGroup,
          `${name}SubnetGroup`,
          {
            subnetIds: vpc.subnets,
          },
          { parent: self },
        ),
      );
    }

    function createParameterGroup() {
      return new rds.ParameterGroup(
        ...transform(
          args.transform?.parameterGroup,
          `${name}ParameterGroup`,
          {
            family: engineVersion.apply((v) => `mysql${v.split(".")[0]}`),
            parameters: [
              {
                name: "rds.force_ssl",
                value: "0",
              },
            ],
          },
          { parent: self },
        ),
      );
    }

    function createSecret() {
      const secret = new secretsmanager.Secret(
        `${name}ProxySecret`,
        {
          recoveryWindowInDays: 0,
        },
        { parent: self },
      );

      new secretsmanager.SecretVersion(
        `${name}ProxySecretVersion`,
        {
          secretId: secret.id,
          secretString: jsonStringify({
            username,
            password,
          }),
        },
        { parent: self },
      );

      return secret;
    }

    function createInstance() {
      return new rds.Instance(
        ...transform(
          args.transform?.instance,
          `${name}Instance`,
          {
            dbName,
            dbSubnetGroupName: subnetGroup.name,
            engine: "mysql",
            engineVersion,
            instanceClass: interpolate`db.${instanceType}`,
            username,
            password,
            parameterGroupName: parameterGroup.name,
            skipFinalSnapshot: true,
            storageEncrypted: true,
            storageType: "gp3",
            allocatedStorage: 20,
            maxAllocatedStorage: storage,
            multiAz,
            backupRetentionPeriod: 7,
            performanceInsightsEnabled: true,
            tags: {
              "sst:component-version": _version.toString(),
              "sst:lookup:password": secret.id,
            },
          },
          { parent: self, deleteBeforeReplace: true },
        ),
      );
    }

    function createReplicas() {
      return output(args.replicas ?? 0).apply((replicas) =>
        Array.from({ length: replicas }).map(
          (_, i) =>
            new rds.Instance(
              `${name}Replica${i}`,
              {
                replicateSourceDb: instance.identifier,
                dbName: interpolate`${instance.dbName}_replica${i}`,
                dbSubnetGroupName: instance.dbSubnetGroupName,
                availabilityZone: instance.availabilityZone,
                engine: instance.engine,
                engineVersion: instance.engineVersion,
                instanceClass: instance.instanceClass,
                username: instance.username,
                password: instance.password.apply((v) => v!),
                parameterGroupName: instance.parameterGroupName,
                skipFinalSnapshot: true,
                storageEncrypted: instance.storageEncrypted.apply((v) => v!),
                storageType: instance.storageType,
                allocatedStorage: instance.allocatedStorage,
                maxAllocatedStorage: instance.maxAllocatedStorage.apply(
                  (v) => v!,
                ),
              },
              { parent: self },
            ),
        ),
      );
    }

    function createProxy() {
      return all([args.proxy]).apply(([proxy]) => {
        if (!proxy) return;

        const credentials = proxy === true ? [] : proxy.credentials ?? [];

        const secrets = credentials.map((credential) => {
          const secret = new secretsmanager.Secret(
            `${name}ProxySecret${credential.username}`,
            {
              recoveryWindowInDays: 0,
            },
            { parent: self },
          );

          new secretsmanager.SecretVersion(
            `${name}ProxySecretVersion${credential.username}`,
            {
              secretId: secret.id,
              secretString: jsonStringify({
                username: credential.username,
                password: credential.password,
              }),
            },
            { parent: self },
          );
          return secret;
        });

        const role = new iam.Role(
          `${name}ProxyRole`,
          {
            assumeRolePolicy: iam.assumeRolePolicyForPrincipal({
              Service: "rds.amazonaws.com",
            }),
            inlinePolicies: [
              {
                name: "inline",
                policy: iam.getPolicyDocumentOutput({
                  statements: [
                    {
                      actions: ["secretsmanager:GetSecretValue"],
                      resources: [secret.arn, ...secrets.map((s) => s.arn)],
                    },
                  ],
                }).json,
              },
            ],
          },
          { parent: self },
        );

        const lookup = new RdsRoleLookup(
          `${name}ProxyRoleLookup`,
          { name: "AWSServiceRoleForRDS" },
          { parent: self },
        );

        const rdsProxy = new rds.Proxy(
          ...transform(
            args.transform?.proxy,
            `${name}Proxy`,
            {
              engineFamily: "MYSQL",
              auths: [
                {
                  authScheme: "SECRETS",
                  iamAuth: "DISABLED",
                  secretArn: secret.arn,
                },
                ...secrets.map((s) => ({
                  authScheme: "SECRETS",
                  iamAuth: "DISABLED",
                  secretArn: s.arn,
                })),
              ],
              roleArn: role.arn,
              vpcSubnetIds: vpc.subnets,
            },
            { parent: self, dependsOn: [lookup] },
          ),
        );

        const targetGroup = new rds.ProxyDefaultTargetGroup(
          `${name}ProxyTargetGroup`,
          {
            dbProxyName: rdsProxy.name,
          },
          { parent: self },
        );

        new rds.ProxyTarget(
          `${name}ProxyTarget`,
          {
            dbProxyName: rdsProxy.name,
            targetGroupName: targetGroup.name,
            dbInstanceIdentifier: instance.identifier,
          },
          { parent: self },
        );

        return rdsProxy;
      });
    }
  }

  public get id() {
    if (this.dev?.enabled) return output("placeholder");
    return this.instance!.identifier;
  }

  public get proxyId() {
    if (this.dev?.enabled) return output("placeholder");

    return this.proxy!.apply((v) => {
      if (!v) {
        throw new VisibleError(
          `Proxy is not enabled. Enable it with "proxy: true".`,
        );
      }
      return v.id;
    });
  }

  public get username() {
    if (this.dev?.enabled) return this.dev.username;
    return this.instance!.username;
  }

  public get password() {
    if (this.dev?.enabled) return this.dev.password;
    return this._password!;
  }

  public get database() {
    if (this.dev?.enabled) return this.dev.database;
    return this.instance!.dbName;
  }

  public get port() {
    if (this.dev?.enabled) return this.dev.port;
    return this.instance!.port;
  }

  public get host() {
    if (this.dev?.enabled) return this.dev.host;

    return all([this.instance!.endpoint, this.proxy!]).apply(
      ([endpoint, proxy]) => proxy?.endpoint ?? output(endpoint.split(":")[0]),
    );
  }

  public get nodes() {
    return {
      instance: this.instance,
    };
  }

  public getSSTLink() {
    return {
      properties: {
        database: this.database,
        username: this.username,
        password: this.password,
        port: this.port,
        host: this.host,
      },
    };
  }

  public static get(
    name: string,
    args: MysqlGetArgs,
    opts?: ComponentResourceOptions,
  ) {
    return new Mysql(
      name,
      {
        ref: true,
        id: args.id,
        proxyId: args.proxyId,
      } as unknown as MysqlArgs,
      opts,
    );
  }
}

const __pulumiType = "sst:aws:Mysql";
// @ts-expect-error
Mysql.__pulumiType = __pulumiType;
