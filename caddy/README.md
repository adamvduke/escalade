# Escalade

[![](https://badge.imagelayers.io/adamvduke/escalade:latest.svg)](https://imagelayers.io/?images=adamvduke/escalade:latest 'Get your own badge on imagelayers.io')

It's a box shaped [caddy](https://caddyserver.com).

Serve a static site with caddy

```
docker run --rm -it -p 80:80 -v path/to/static/site:/srv/caddy/public adamvduke/escalade
```

Replace the prebuilt image's Caddyfile

```
docker run --rm -it -p 80:80 -v path/to/caddyfile/dir:/srv/caddy/config adamvduke/escalade
```
