#!/bin/sh
#
set -ex

app_name=$1

if [ -z "$app_name" ]; then
  echo "No app name given."
  exit 1
fi

git push $app_name master
heroku run --app=$app_name bin/rake db:migrate
heroku info --app=$app_name
