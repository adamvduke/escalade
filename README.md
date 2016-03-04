# Escalade

## Why?

Strong encryption and [encrypting the web](https://www.eff.org/encrypt-the-web)
have been big issues in the last few years.

[Let's Encrypt](https://letsencrypt.org/)
goes a long way in making it super easy to get a TLS certificate for your site.

[Caddy](https://caddyserver.com) takes it a step further by fetching certificates
for your site on demand.

[Github Pages](https://pages.github.com/) is awesome at serving static or jekyll
based sites, but doesn't currently support TLS with a custom domain name.

Escalade's goal is to combine software/concepts from all three to make it easy
to host your static sites over TLS.

## How?

Instead of github hosting your static site or jekyll site, escalade will host it
for you. Escalade will generate your static site from source hosted on github and
use [caddy](https://caddyserver.com) to host it. If the DNS for your domain is
configured to direct traffic for your site to the machine where escalade is running,
it will fetch a TLS certificate for your domain and start serving your site
immediately.

## Status

Currently, escalade is a proof of concept, but it's moving toward being deployable
soon. At the moment, it is possible to manually deploy/configure the rails application
and have it do the site generation, caddy config generation, and caddy restart.
It would be nice to make the project as easily deployable as possible and also
implement a way to receive a webhook from github to trigger a new build of the site.


```
```
