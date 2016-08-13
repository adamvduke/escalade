FROM ruby:2.3.0
MAINTAINER Adam Duke <adam.v.duke@gmail.com>

RUN apt-get update && apt-get install -y cmake git libpq-dev postgresql-client nodejs netcat-openbsd

ENV APP_DIR /srv/escalade-rails/current
ENV BUNDLER_DIR /srv/escalade-rails/shared/vendor

WORKDIR $APP_DIR

# Put in just Gemfile, and the required dependency gemspec first so that we can cache the
# bundle install based on whether the Gemfile/Gemfile.lock have changed.
COPY Gemfile* $APP_DIR/

RUN bundle install --jobs=3 --path=$BUNDLER_DIR --full-index

COPY . $APP_DIR/

VOLUME [ "/srv/escalade/caddy/config", "/srv/sites", "/srv/escalade-rails/current/public"]

ENTRYPOINT ["/srv/escalade-rails/current/docker-entrypoint.sh"]

CMD ["rails", "s", "--binding", "0.0.0.0"]

EXPOSE 3000
