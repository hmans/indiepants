#!/bin/sh
#
# A bootstrapping script for Heroku, until PostgreSQL 9.4 enters GA
# and app.json magically starts working again.
#
set -ex

app_name=$1

if [ -z "$app_name" ]; then
  echo "No app name given."
  exit 1
fi

heroku create $app_name -r $app_name
heroku addons:add heroku-postgresql --version=9.4 --app=$app_name
git push $app_name master
heroku run --app=$app_name bin/rake db:migrate
heroku info --app=$app_name
