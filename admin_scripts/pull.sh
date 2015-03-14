#!/bin/bash
# Use to install the latest cyber-dojo git repo onto a cyber-dojo server

cyberDojoHome=/var/www/cyber-dojo
cd $cyberDojoHome

# get latest source from https://github.com/JonJagger/cyber-dojo
# if it asks for a password just hit return
git pull --no-edit origin master
ret=$?
if [ $ret -ne 0 ]; then
  exit
fi

echo "deleting the rails cache"
rm -rf $cyberDojoHome/tmp/*

echo "refreshing the exercises/ cache"
$cyberDojoHome/exercises/cache.rb

echo "refreshing the languages/ cache"
$cyberDojoHome/languages/cache.rb

echo "poking rails"
bundle install

echo "restarting apache"
service apache2 restart

