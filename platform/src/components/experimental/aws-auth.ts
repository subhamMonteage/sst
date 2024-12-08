import {
  ComponentResourceOptions,
  jsonStringify,
  Output,
  output,
  secret,
} from "@pulumi/pulumi";
import { Component, Transform } from "../component";
import { Link } from "../link";
import { s3 } from "@pulumi/aws";
import { FunctionArgs, Function, Dynamo } from "../aws";
import { functionBuilder } from "../aws/helpers/function-builder";
import { env } from "../linkable";

export interface AuthArgs {
  authenticator: string | FunctionArgs;
  transform?: {
    bucketPolicy?: Transform<s3.BucketPolicyArgs>;
  };
}

export class AwsAuth extends Component implements Link.Linkable {
  private readonly _authenticator: Output<Function>;

  constructor(name: string, args: AuthArgs, opts?: ComponentResourceOptions) {
    super(__pulumiType, name, args, opts);
    const table = new sst.aws.Dynamo("LambdaAuthTable", {
      fields: {
        pk: "string",
        sk: "string",
      },
      ttl: "expiry",
      primaryIndex: {
        hashKey: "pk",
        rangeKey: "sk",
      },
    });

    this._authenticator = functionBuilder(
      `${name}Authenticator`,
      args.authenticator,
      {
        link: [table],
      },
      (args) => {
        args.environment = output(args.environment).apply((env) => ({
          ...env,
          OPENAUTH_STORAGE: jsonStringify({
            type: "dynamo",
            options: {
              table: table.name,
            },
          }),
        }));
      },
    ).apply((v) => v.getFunction());
  }

  public get authenticator() {
    return this._authenticator;
  }

  public get url() {
    return this._authenticator.url!;
  }

  /** @internal */
  public getSSTLink() {
    return {
      properties: {
        url: this.url,
      },
      include: [
        env({
          OPENAUTH_ISSUER: this.url,
        }),
      ],
    };
  }
}

const __pulumiType = "sst:aws:Auth";
// @ts-expect-error
Auth.__pulumiType = __pulumiType;
