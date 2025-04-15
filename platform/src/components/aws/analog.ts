import fs from "fs";
import path from "path";
import { ComponentResourceOptions, Output } from "@pulumi/pulumi";
import { VisibleError } from "../error.js";
import { Plan, SsrSite, SsrSiteArgs } from "./ssr-site.js";

export interface AnalogArgs extends SsrSiteArgs {
  /**
   * Configure how this component works in `sst dev`.
   *
   * :::note
   * In `sst dev` your Analog app is run in dev mode; it's not deployed.
   * :::
   *
   * Instead of deploying your Analog app, this starts it in dev mode. It's run
   * as a separate process in the `sst dev` multiplexer. Read more about
   * [`sst dev`](/docs/reference/cli/#dev).
   *
   * To disable dev mode, pass in `false`.
   */
  dev?: SsrSiteArgs["dev"];
  /**
   * Permissions and the resources that the [server function](#nodes-server) in your Analog app needs to access. These permissions are used to create the function's IAM role.
   *
   * :::tip
   * If you `link` the function to a resource, the permissions to access it are
   * automatically added.
   * :::
   *
   * @example
   * Allow reading and writing to an S3 bucket called `my-bucket`.
   * ```js
   * {
   *   permissions: [
   *     {
   *       actions: ["s3:GetObject", "s3:PutObject"],
   *       resources: ["arn:aws:s3:::my-bucket/*"]
   *     },
   *   ]
   * }
   * ```
   *
   * Perform all actions on an S3 bucket called `my-bucket`.
   *
   * ```js
   * {
   *   permissions: [
   *     {
   *       actions: ["s3:*"],
   *       resources: ["arn:aws:s3:::my-bucket/*"]
   *     },
   *   ]
   * }
   * ```
   *
   * Grant permissions to access all resources.
   *
   * ```js
   * {
   *   permissions: [
   *     {
   *       actions: ["*"],
   *       resources: ["*"]
   *     },
   *   ]
   * }
   * ```
   */
  permissions?: SsrSiteArgs["permissions"];
  /**
   * Path to the directory where your Analog app is located.  This path is relative to your `sst.config.ts`.
   *
   * By default it assumes your Analog app is in the root of your SST app.
   * @default `"."`
   *
   * @example
   *
   * If your Analog app is in a package in your monorepo.
   *
   * ```js
   * {
   *   path: "packages/web"
   * }
   * ```
   */
  path?: SsrSiteArgs["path"];
  /**
   * [Link resources](/docs/linking/) to your Analog app. This will:
   *
   * 1. Grant the permissions needed to access the resources.
   * 2. Allow you to access it in your site using the [SDK](/docs/reference/sdk/).
   *
   * @example
   *
   * Takes a list of resources to link to the function.
   *
   * ```js
   * {
   *   link: [bucket, stripeKey]
   * }
   * ```
   */
  link?: SsrSiteArgs["link"];
  /**
   * Configure how the CloudFront cache invalidations are handled. This is run after your Analog app has been deployed.
   * :::tip
   * You get 1000 free invalidations per month. After that you pay $0.005 per invalidation path. [Read more here](https://aws.amazon.com/cloudfront/pricing/).
   * :::
   * @default `{paths: "all", wait: false}`
   * @example
   * Wait for all paths to be invalidated.
   * ```js
   * {
   *   invalidation: {
   *     paths: "all",
   *     wait: true
   *   }
   * }
   * ```
   */
  invalidation?: SsrSiteArgs["invalidation"];
  /**
   * Set [environment variables](https://analogjs.org/docs/guides/migrating#using-environment-variables) in your Analog app. These are made available:
   *
   * 1. In `ng build`, they are loaded into `process.env`.
   * 2. Locally while running `sst dev ng serve`.
   *
   * :::tip
   * You can also `link` resources to your Analog app and access them in a type-safe way with the [SDK](/docs/reference/sdk/). We recommend linking since it's more secure.
   * :::
   *
   * Only variables prefixed with `VITE_` are available in the browser.
   *
   * @example
   * ```js
   * {
   *   environment: {
   *     API_URL: api.url,
   *     // Accessible in the browser
   *     VITE_STRIPE_PUBLISHABLE_KEY: "pk_test_123"
   *   }
   * }
   * ```
   */
  environment?: SsrSiteArgs["environment"];
  /**
   * Set a custom domain for your Analog app.
   *
   * Automatically manages domains hosted on AWS Route 53, Cloudflare, and Vercel. For other
   * providers, you'll need to pass in a `cert` that validates domain ownership and add the
   * DNS records.
   *
   * :::tip
   * Built-in support for AWS Route 53, Cloudflare, and Vercel. And manual setup for other
   * providers.
   * :::
   *
   * @example
   *
   * By default this assumes the domain is hosted on Route 53.
   *
   * ```js
   * {
   *   domain: "example.com"
   * }
   * ```
   *
   * For domains hosted on Cloudflare.
   *
   * ```js
   * {
   *   domain: {
   *     name: "example.com",
   *     dns: sst.cloudflare.dns()
   *   }
   * }
   * ```
   *
   * Specify a `www.` version of the custom domain.
   *
   * ```js
   * {
   *   domain: {
   *     name: "domain.com",
   *     redirects: ["www.domain.com"]
   *   }
   * }
   * ```
   */
  domain?: SsrSiteArgs["domain"];
  /**
   * Serve your Analog app through a `Router` component instead of a standalone CloudFront
   * distribution.
   *
   * Let's say you have a Router component.
   *
   * ```ts title="sst.config.ts"
   * const router = new sst.aws.Router("Router", {
   *   domain: "*.example.com",
   * });
   * ```
   *
   * You can then match a pattern and route to your app based on:
   *
   * - A path like `/docs`
   * - A domain pattern like `docs.example.com`
   * - A combined pattern like `dev.example.com/docs`
   *
   * For example, to match a path.
   *
   * ```ts title="sst.config.ts"
   * {
   *   route: {
   *     router,
   *     path: "/docs",
   *   },
   * }
   * ```
   *
   * Or match a domain.
   *
   * ```ts title="sst.config.ts"
   * {
   *   route: {
   *     router,
   *     domain: "docs.example.com",
   *   },
   * }
   * ```
   *
   * Route by both domain and path:
   *
   * ```ts title="sst.config.ts"
   * {
   *   route: {
   *     router,
   *     domain: "dev.example.com",
   *     path: "/docs",
   *   },
   * }
   * ```
   *
   * If you are routing to a path like `/docs`, you must configure the
   * base path in your Analog app. The base path must match the path in your
   * route prop.
   *
   * :::caution
   * If routing to a path, you need to configure that as the base path in your
   * Analog app as well.
   * :::
   *
   * For example, if you are routing `/docs` to an Analog app, you need to set
   * the `base` and `apiPrefix` options in your `vite.config.ts`. The `apiPrefix`
   * value should not begin with a slash.
   *
   * ```js {4,7} title="vite.config.ts"
   * export default defineConfig(({ mode }) => ({
   *   plugins: [
   *     analog({
   *       apiPrefix: "docs/api"
   *     })
   *   ],
   *   base: "/docs"
   * }));
   * ```
   */
  route?: SsrSiteArgs["route"];
  /**
   * The command used internally to build your Analog app.
   *
   * @default `"npm run build"`
   *
   * @example
   *
   * If you want to use a different build command.
   * ```js
   * {
   *   buildCommand: "yarn build"
   * }
   * ```
   */
  buildCommand?: SsrSiteArgs["buildCommand"];
  /**
   * Configure how the Analog app assets are uploaded to S3.
   *
   * By default, this is set to the following. Read more about these options below.
   * ```js
   * {
   *   assets: {
   *     textEncoding: "utf-8",
   *     versionedFilesCacheHeader: "public,max-age=31536000,immutable",
   *     nonVersionedFilesCacheHeader: "public,max-age=0,s-maxage=86400,stale-while-revalidate=8640"
   *   }
   * }
   * ```
   */
  assets?: SsrSiteArgs["assets"];
  /**
   * Configure the Analog app to use an existing CloudFront cache policy.
   *
   * :::note
   * CloudFront has a limit of 20 cache policies per account, though you can request a limit
   * increase.
   * :::
   *
   * By default, a new cache policy is created for it. This allows you to reuse an existing
   * policy instead of creating a new one.
   *
   * @default A new cache policy is created
   * @example
   * ```js
   * {
   *   cachePolicy: "658327ea-f89d-4fab-a63d-7e88639e58f6"
   * }
   * ```
   */
  cachePolicy?: SsrSiteArgs["cachePolicy"];
}

/**
 * The `Analog` component lets you deploy a [Analog](https://analogjs.org) app to AWS.
 *
 * @example
 *
 * #### Minimal example
 *
 * Deploy an Analog app that's in the project root.
 *
 * ```js title="sst.config.ts"
 * new sst.aws.Analog("MyWeb");
 * ```
 *
 * #### Change the path
 *
 * Deploys the Analog app in the `my-analog-app/` directory.
 *
 * ```js {2} title="sst.config.ts"
 * new sst.aws.Analog("MyWeb", {
 *   path: "my-analog-app/"
 * });
 * ```
 *
 * #### Add a custom domain
 *
 * Set a custom domain for your Analog app.
 *
 * ```js {2} title="sst.config.ts"
 * new sst.aws.Analog("MyWeb", {
 *   domain: "my-app.com"
 * });
 * ```
 *
 * #### Redirect www to apex domain
 *
 * Redirect `www.my-app.com` to `my-app.com`.
 *
 * ```js {4} title="sst.config.ts"
 * new sst.aws.Analog("MyWeb", {
 *   domain: {
 *     name: "my-app.com",
 *     redirects: ["www.my-app.com"]
 *   }
 * });
 * ```
 *
 * #### Link resources
 *
 * [Link resources](/docs/linking/) to your Analog app. This will grant permissions
 * to the resources and allow you to access it in your app.
 *
 * ```ts {4} title="sst.config.ts"
 * const bucket = new sst.aws.Bucket("MyBucket");
 *
 * new sst.aws.Analog("MyWeb", {
 *   link: [bucket]
 * });
 * ```
 *
 * You can use the [SDK](/docs/reference/sdk/) to access the linked resources
 * in your Analog app.
 *
 * ```ts title="src/app/app.config.ts"
 * import { Resource } from "sst";
 *
 * console.log(Resource.MyBucket.name);
 * ```
 */
export class Analog extends SsrSite {
  constructor(
    name: string,
    args: AnalogArgs = {},
    opts: ComponentResourceOptions = {},
  ) {
    super(__pulumiType, name, args, opts);
  }

  protected normalizeBuildCommand() {}

  protected buildPlan(outputPath: Output<string>): Output<Plan> {
    return outputPath.apply((outputPath) => {
      const nitro = JSON.parse(
        fs.readFileSync(
          path.join(outputPath, "dist", "analog", "nitro.json"),
          "utf-8",
        ),
      );

      if (!["aws-lambda"].includes(nitro.preset)) {
        throw new VisibleError(
          `Analog's vite.config.ts must be configured to use the "aws-lambda" preset. It is currently set to "${nitro.preset}".`,
        );
      }

      const basepath = fs
        .readFileSync(path.join(outputPath, "vite.config.ts"), "utf-8")
        .match(/base: ['"](.*)['"]/)?.[1];

      return {
        base: basepath,
        server: {
          description: "Server handler for Analog",
          handler: "index.handler",
          bundle: path.join(outputPath, "dist", "analog", "server"),
        },
        assets: [
          {
            from: path.join("dist", "analog", "public"),
            to: "",
            cached: true,
          },
        ],
      };
    });
  }

  /**
   * The URL of the Analog app.
   *
   * If the `domain` is set, this is the URL with the custom domain.
   * Otherwise, it's the autogenerated CloudFront URL.
   */
  public get url() {
    return super.url;
  }
}

const __pulumiType = "sst:aws:Analog";
// @ts-expect-error
Analog.__pulumiType = __pulumiType;
