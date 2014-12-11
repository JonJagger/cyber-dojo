#!/bin/bash
# Use to install the latest cyber-dojo git repo onto a cyber-dojo server

if [ -d "/var/www/cyber-dojo" ]; then
  export cyberDojoName=cyber-dojo
else
  export cyberDojoName=cyberdojo
fi

export cyberDojoHome=/var/www/$cyberDojoName

cd $cyberDojoHome

# get latest source from https://github.com/JonJagger/cyber-dojo
# if it asks for a password just hit return
git pull --no-edit origin master
ret=$?
if [ $ret -ne 0 ]; then
  exit
fi

# cyber-dojo creates folders under katas
apt-get install -y acl
chmod g+rwsx katas
setfacl -d -m group:www-data:rwx $cyberDojoHome/katas
setfacl -m group:www-data:rwx $cyberDojoHome/katas

# tests create folders under tests/cyberdojo/katas
chmod g+rwsx $cyberDojoHome/tests/cyberdojo/katas
setfacl -d -m group:www-data:rwx $cyberDojoHome/tests/cyberdojo/katas
setfacl -m group:www-data:rwx $cyberDojoHome/tests/cyberdojo/katas

# ensure pulled files have correct rights
for folder in app config exercises languages lib log notes public script spec test
do
  echo "chown/chgrp www-data ${folder}"
  chown -R www-data $cyberDojoHome/$folder
  chgrp -R www-data $cyberDojoHome/$folder
done

echo "chown/chgrp www-data *"
chown www-data $cyberDojoHome/*
chgrp www-data $cyberDojoHome/*

echo "chown/chgrp www-data .*"
chown www-data $cyberDojoHome/.*
chgrp www-data $cyberDojoHome/.*

echo "chown/chgrp www-data tmp/cache"
mkdir -p tmp/cache
chown www-data $cyberDojoHome/tmp/cache
chgrp www-data $cyberDojoHome/tmp/cache

echo "refresh exercises/ cache"
$cyberDojoHome/exercises/cache.rb

echo "refresh languages/ cache"
$cyberDojoHome/languages/cache.rb

# poke rails
bundle install

# restart apache
service apache2 restart
