# WaiverForever OpenAPI SPEC

## Links

- Documentation: https://docs.waiverforever.com/

## Working on specification

### Install

1. Install [Ruby 2.5 or newer](https://www.ruby-lang.org/)
2. `gem install bundler`
2. Clone repo and `cd`
    + Run `bundle install`
    + Run `bundle exec middleman server`

You can now see the docs at http://localhost:4567

Powered by [slate](https://github.com/lord/slate).


## Development Gateway migration

The permanent dev preview is `https://open-api-doc.dev-waiverforeverk8s.com/`.
Its Deployment is currently absent from the cluster, so CI must first restore the static
documentation container before any DNS cutover. Use the existing `build` and
`hold-deploy-to-k8s-dev` -> `deploy-to-k8s-dev` workflow; do not add a separate profile/gate.
The dev overlay now publishes two HTTPRoutes and a Gateway-only request policy instead of
the old source Ingress. The Service and selector remain; the Deployment has a root readiness
probe so the restored preview is not marked available until it serves its index.

The existing shared development Gateway/NLB preserves external Host/path/query, HTTPS
forwarded headers, 1 MiB request-only buffering, 5s connect and 300s inactivity. Responses
are not buffered. The buffer is default disabled, enabled only for the exact documentation
route; controlled retries are zero. This is a public preview like the old entry: no SAML
policy is added. Existing sources, production job, deploy.sh, gh-pages and CNAME remain.

Feature push runs the existing image build and waits at the existing dev approval gate.
Approving dev restores one Deployment and publishes dev routing. It does not change DNS.
After CI completes, compare index, CSS/JS/image paths, query-preserving HTTP301, workload
readiness/restarts and both Gateways' effective policies/unrelated-host isolation. No useful
old-page equality baseline exists: the old dev host returns503 with zero ready endpoints.

Only after a healthy preview is accepted, the operator changes this one dev DNS record to:
`a0ad714b77fb34f0e91fe613f2e85bb3-d90877b8e5f0fc5d.elb.us-east-1.amazonaws.com`.
The old Ingress remains live until separately approved cleanup; source removal does not
prune it. All Google/SAML and production docs.waiverforever.com settings stay unchanged.
Merge to master retains the existing automatic production gh-pages publication, so merging
is a separate operational action; do not merge just to publish the dev preview.


The legacy Docker build stage still uses the existing Ruby2.6/locked Slate dependencies.
Its Debian11 package sources now point to the official Debian archive because the active
security mirror returns404 for referenced packages. Archive metadata expiry checking is
turned off for those two archive sources only; package signature and HTTPS checks remain.
This is a Docker builder repair, not a Ruby/Gem upgrade or a production publishing change.
