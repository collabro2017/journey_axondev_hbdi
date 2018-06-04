#!/bin/sh

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle exec rake db:create:schema
bundle exec rake db:migrate
exec bundle exec rails server 
