import { ComponentResourceOptions, Input, all, output } from "@pulumi/pulumi";
import { Component } from "../component";
import {
  buildKvNamespace,
  createKvRouteData,
  parsePattern,
  RouterBaseRouteArgs,
  updateKvRoutes,
} from "./router-base-route";

export interface Args extends RouterBaseRouteArgs {
  /**
   * The host to route to.
   */
  host: Input<string>;
}

/**
 * The `RouterUrlRoute` component is internally used by the `Router` component
 * to add routes.
 *
 * :::note
 * This component is not intended to be created directly.
 * :::
 *
 * You'll find this component returned by the `route` method of the `Router` component.
 */
export class RouterUrlRoute extends Component {
  constructor(name: string, args: Args, opts?: ComponentResourceOptions) {
    super(__pulumiType, name, args, opts);

    const self = this;

    all([args.pattern, args.rewrite]).apply(([pattern, rewrite]) => {
      const patternData = parsePattern(pattern);
      const namespace = buildKvNamespace(name);
      createKvRouteData(name, args, self, namespace, {
        host: args.host,
        rewrite,
      });
      updateKvRoutes(name, args, self, "url", namespace, patternData);
    });
  }
}

const __pulumiType = "sst:aws:RouterUrlRoute";
// @ts-expect-error
RouterUrlRoute.__pulumiType = __pulumiType;
