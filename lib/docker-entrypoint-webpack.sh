#!/bin/bash
# https://stackoverflow.com/a/38732187/1935918

cd /app
bundle install
yarn install

exec bundle exec "$@"
