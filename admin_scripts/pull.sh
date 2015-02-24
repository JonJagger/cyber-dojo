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

apt-get install -y acl

echo "refreshing exercises/ cache"
$cyberDojoHome/exercises/cache.rb

echo "refreshing languages/ cache"
$cyberDojoHome/languages/cache.rb

# cyber-dojo creates folders under katas
echo "chown/chgrp www-data katas"
chmod g+rwsx katas
setfacl -d -m group:www-data:rwx $cyberDojoHome/katas
setfacl -m group:www-data:rwx $cyberDojoHome/katas

# ensure pulled files have correct rights
for folder in app config exercises languages lib log notes public script spec test
do
  echo "chown www-data:www-data ${folder}"
  chown -R www-data:www-data $cyberDojoHome/$folder
done

# tests create folders under tests/cyber-dojo/katas
echo "chown www-data test/cyber-dojo"
chmod g+rwsx $cyberDojoHome/test/cyber-dojo
setfacl -d -m group:www-data:rwx $cyberDojoHome/test/cyber-dojo
setfacl -m group:www-data:rwx $cyberDojoHome/test/cyber-dojo

echo "poking rails"
bundle install

echo "restarting apache"
service apache2 restart

echo "chown www-data:www-data *"
chown www-data:www-data $cyberDojoHome/*

echo "chown www-data:www-data .*"
chown www-data:www-data $cyberDojoHome/.*

echo "chown -R www-data:www-data tmp"
rm -rf tmp/cache
mkdir -p tmp/cache
chown -R www-data:www-data $cyberDojoHome/tmp
