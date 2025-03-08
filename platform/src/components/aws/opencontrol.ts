import { all, ComponentResourceOptions, Output } from "@pulumi/pulumi";
import { RandomPassword } from "@pulumi/random";
import { Component } from "../component";
import { FunctionArgs, Function } from ".";
import { functionBuilder } from "./helpers/function-builder";
import { Input } from "../input";

export interface OpenControlArgs {
  /**
   * The function that's running your OpenControl server.
   *
   * @example
   * ```js
   * {
   *   server: "src/server.handler"
   * }
   * ```
   *
   * You can also pass in the full `FunctionArgs`.
   *
   * ```js
   * {
   *   server: {
   *     handler: "src/server.handler",
   *     link: [table]
   *   }
   * }
   * ```
   *
   * Since the `server` function is a Hono app, you want to export it with the Lambda adapter.
   *
   * ```ts title="src/server.ts"
   * import { handle } from "hono/aws-lambda";
   * import { create } from "opencontrol";
   *
   * const app = create({
   *   // ...
   * });
   *
   * export const handler = handle(app);
   * ```
   *
   * Learn more on the [OpenControl docs](https://opencontrol.js.org/docs/server/) on how to
   * configure the `server` function.
   */
  server: Input<string | FunctionArgs>;
}

/**
 * The `OpenControl` component lets you create centralized OpenControl servers on AWS. It
 * deploys [OpenControl](https://opencontrol.js.org) to [AWS Lambda](https://aws.amazon.com/lambda/).
 *
 * :::note
 * OpenControl is currently in beta.
 * :::
 *
 * @example
 *
 * #### Create an OpenControl server
 *
 * ```ts title="sst.config.ts"
 * const server = new sst.aws.OpenControl("MyServer", {
 *   server: "src/server.handler"
 * });
 * ```
 *
 * Where the `server` function might look like this.
 *
 * ```ts title="src/server.ts"
 * import { handle } from "hono/aws-lambda";
 * import { create } from "opencontrol";
 * import { tool } from "opencontrol/tool";
 *
 * const myTool = tool({
 *   name: "my_tool",
 *   description: "Get the most popular greeting",
 *   async run() {
 *     return "Hello, world!";
 *   },
 * });
 *
 * const app = create({
 *   key: process.env.OPENCONTROL_KEY,
 *   tools: [myTool],
 * });
 *
 * export const handler = handle(app);
 * ```
 *
 * Learn more on the [OpenControl docs](https://opencontrol.js.org/docs/server/) on how to
 * configure the `server` function.
 */
export class OpenControl extends Component {
  private readonly _server: Output<Function>;
  private readonly _key: Output<string>;

  constructor(
    name: string,
    args: OpenControlArgs,
    opts?: ComponentResourceOptions,
  ) {
    super(__pulumiType, name, args, opts);
    const self = this;

    const key = createKey();
    const server = createServer();

    this._server = server;
    this._key = key;
    registerOutputs();

    function registerOutputs() {
      self.registerOutputs({
        _hint: self.url,
      });
    }

    function createKey() {
      return new RandomPassword(
        `${name}Key`,
        {
          length: 16,
          special: false,
        },
        { parent: self },
      ).result;
    }

    function createServer() {
      return functionBuilder(
        `${name}Server`,
        args.server,
        {
          link: [],
          environment: {
            OPENCONTROL_KEY: key,
          },
          policies: ["arn:aws:iam::aws:policy/ReadOnlyAccess"],
          url: true,
          _skipHint: true,
        },
        (args) => {
          args.url = {
            cors: false,
          };
        },
        { parent: self },
      ).apply((v) => v.getFunction());
    }
  }

  /**
   * The URL of the OpenControl server.
   */
  public get url() {
    return all([this._server.url, this._key]).apply(
      ([url, key]) => `${url}${key}`,
    );
  }

  /**
   * The underlying [resources](/docs/components/#nodes) this component creates.
   */
  public get nodes() {
    return {
      /**
       * The Function component for the server.
       */
      server: this._server,
    };
  }
}

const __pulumiType = "sst:aws:OpenControl";
// @ts-expect-error
OpenControl.__pulumiType = __pulumiType;
