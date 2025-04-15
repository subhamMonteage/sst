// @ts-check
import { defineConfig } from "astro/config";
import aws from "astro-sst";
//import aws from "../../../../../../astro-sst/packages/astro-sst/dist/adapter";

// https://astro.build/config
export default defineConfig({
  image: {
    domains: ["sst.dev"],
  },
  output: "static",
  adapter: aws(),
  redirects: {
    "/redirect-to-route": "/prerendered",
    "/redirect-to-url": "https://www.google.com",
    "/redirect/[slug]": "/sub/[slug]",
  },
});
