#!/bin/bash
# https://stackoverflow.com/a/38732187/1935918

set -e
sleep 10 # wait for the database to be ready

if [ -f /app/tmp/pids/server.pid ]; then
  rm /app/tmp/pids/server.pid
fi

cd /app
bundle install
yarn install
bundle exec rails i18n:js:export

if [ "$RESET_DB_ON_FAIL" == "true" ]; then
  echo resetting db on fail
  if [ ! -f /app/db/schema.rb ]; then
    bin/rails db:environment:set RAILS_ENV=development
    bundle exec rails db:drop
    bundle exec rails db:create && bundle exec rails db:migrate && bundle exec rake db:migrate RAILS_ENV=test && bundle exec rails db:seed;
  else
    bundle exec rails db:migrate && bundle exec rails db:seed || { bundle exec rails db:drop && bundle exec rails db:create && bundle exec rails db:migrate && bundle exec rake db:migrate RAILS_ENV=test && bundle exec rails db:seed; }
  fi
else
  echo not resetting db on fail
  bundle exec rails db:migrate && bundle exec rails db:seed || { bundle exec rails db:setup; }
fi

exec bundle exec "$@"
