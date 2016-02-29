FROM ubuntu
MAINTAINER Adam Duke <adam.v.duke@gmail.com>

RUN apt-get update && apt-get install -y ca-certificates

ENV SITE_ROOT /srv/caddy
ENV CONFIG_DIR $SITE_ROOT/config/
ENV PUBLIC_DIR $SITE_ROOT/public/

COPY bin/caddy /caddy
COPY config/Caddyfile $CONFIG_DIR/Caddyfile
COPY public/index.html $PUBLIC_DIR/index.html

WORKDIR $CONFIG_DIR

VOLUME [ "/srv/config" ]

CMD ["/caddy"]

EXPOSE 80
EXPOSE 443
