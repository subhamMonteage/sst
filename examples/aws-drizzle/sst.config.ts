/// <reference path="./.sst/platform/config.d.ts" />

export default $config({
  app(input) {
    return {
      name: "aws-drizzle",
      removal: input?.stage === "production" ? "retain" : "remove",
      home: "aws",
    };
  },
  async run() {
    const vpc = new sst.aws.Vpc("MyVpc", { bastion: true, nat: "ec2" });
    const rds = new sst.aws.Postgres("MyPostgres", { vpc, proxy: true });

    new sst.aws.Function("MyApi", {
      vpc,
      url: true,
      link: [rds],
      handler: "src/api.handler",
    });

    const migrator = new sst.aws.Function("DatabaseMigrator", {
      handler: "src/migrator.handler",
      link: [rds],
      vpc,
      copyFiles: [
        {
          from: "migrations",
          to: "./migrations",
        },
      ],
    });

    if (!$dev){
      new aws.lambda.Invocation("DatabaseMigratorInvocation", {
        input: Date.now().toString(),
        functionName: migrator.name,
      });
    }

    new sst.x.DevCommand("Studio", {
      link: [rds],
      dev: {
        command: "npx drizzle-kit studio",
      },
    });
  },
});
