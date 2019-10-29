#!/bin/bash
echo 'Running potential asset precompile'
if [ ! -z $1 ] && [ $1 == "not" ] ; then
  echo "precompile = not, so not running precompile"
  exit 0
fi

export RAILS_ENV=production
export NODE_ENV=production
export SECRET_KEY_BASE=build

bundle exec rake assets:precompile
bundle exec rake webpacker:compile
