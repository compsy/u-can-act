#!/bin/bash
user=kfyjbcikdgxzom 
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:drop 
bundle exec rake db:create
psql -h docker.io -p 5433 -c "DROP USER IF EXISTS $user;"
createuser -h docker.io -p 5433 -s $user 
psql -h docker.io -p 5433 -c "ALTER USER $user WITH PASSWORD '!!!!!!!!!!!!!!PASSWORD!!!!!!!!!';"
pg_restore -h docker.io -p 5433 -d vsv_development ~/vsv-data/backup/backup/pgbackup.dump
be rake db:migrate
be rake db:seed
