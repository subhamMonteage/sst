import { all, CustomResourceOptions } from "@pulumi/pulumi";
import { Semaphore } from "../../../util/semaphore";
import { local } from "@pulumi/command";
import { Router } from "../router";
import { Input } from "../../input";

const limiter = new Semaphore(
  parseInt(process.env.SST_BUILD_CONCURRENCY_SITE || "1"),
);

export function siteBuilder(
  name: string,
  args: local.CommandArgs,
  opts?: CustomResourceOptions,
) {
  // Wait for the all args values to be resolved before acquiring the semaphore
  return all([args]).apply(async ([args]) => {
    await limiter.acquire(name);

    let waitOn;

    const command = new local.Command(name, args, opts);
    waitOn = command.urn;

    // When running `sst diff`, `local.Command`'s `create` and `update` are not called.
    // So we will also run `local.runOutput` to get the output of the command.
    if ($cli.command === "diff") {
      waitOn = local.runOutput(
        {
          command: args.create!,
          dir: args.dir,
          environment: args.environment,
        },
        opts,
      ).stdout;
    }

    return waitOn.apply(() => {
      limiter.release();
      return command;
    });
  });
}

export interface SiteRouteArgs {
  /**
   * The `Router` component to use to serve your site.
   *
   * @example
   *
   * Let's say you have a Router component.
   *
   * ```ts title="sst.config.ts"
   * const router = new sst.aws.Router("MyRouter", {
   *   domain: "example.com",
   * });
   * ```
   *
   * Then serve your site through the Router.
   *
   * ```ts title="sst.config.ts"
   * route: {
   *   router,
   * }
   * ```
   */
  router: Input<Router>;
  /**
   * The domain pattern to match for the `Router`.
   *
   * @example
   *
   * You can serve your site from a subdomain. For example, if you want to serve
   * your site at `https://dev.example.com`, set the `Router` domain to a wildcard.
   *
   * ```ts {2} title="sst.config.ts"
   * const router = new sst.aws.Router("MyRouter", {
   *   domain: "*.example.com",
   * });
   * ```
   *
   * Then set the subdomain on the site.
   *
   * ```ts {3} title="sst.config.ts"
   * route: {
   *   router,
   *   domain: "dev.example.com",
   * }
   * ```
   */
  domain?: Input<string>;
  /**
   * The path prefix to match for the `Router`.
   *
   * @default `"/"`
   * @example
   *
   * You can serve your site from a subpath. For example, if you want to serve
   * your site at `https://my-app.com/docs`, set the path.
   *
   * ```ts {3} title="sst.config.ts"
   * route: {
   *   router,
   *   path: "/docs",
   * }
   * ```
   */
  path?: Input<string>;
}
