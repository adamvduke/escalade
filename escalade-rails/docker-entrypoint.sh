#!/bin/bash

set -e

if [[ "$1" =~ ^bash ]]; then
  exec "$@"
fi

RAILS_ENV="${RAILS_ENV:-development}"
RUN_ENTRYPOINT="${RUN_ENTRYPOINT:-1}"

BUNDLE=$(which bundle)

if [[ $RUN_ENTRYPOINT = 1 ]]; then
  sleep 8
  case $RAILS_ENV in
  development)
    psql --list -h postgres -U postgres | grep 'escalade' && $BUNDLE exec rake db:migrate db:seed || $BUNDLE exec rake db:create db:migrate db:seed
    ;;
  test)
    psql --list -h postgres -U postgres | grep 'escalade' && $BUNDLE exec rake db:migrate db:seed || $BUNDLE exec rake db:create db:migrate db:seed
    ;;
  production)
    psql --list -h postgres -U postgres | grep 'escalade' && $BUNDLE exec rake assets:precompile db:migrate || $BUNDLE exec rake db:create db:migrate assets:precompile
    ;;
  *)
    echo "Unknown rails env: '$RAILS_ENV'. Valid options: development, test, production"
    exit 1
    ;;
  esac
fi

exec $BUNDLE exec "$@"
