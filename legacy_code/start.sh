#! /usr/bin/execlineb -P

with-contenv
s6-setuidgid app
cd /home/app
bundle exec rails s -b 0.0.0.0
