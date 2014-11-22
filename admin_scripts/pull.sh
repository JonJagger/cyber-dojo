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
chmod g+s katas

# ensure pulled files have correct rights
# don't chmod or chgrp the katas folder (no need and very large)
for folder in app config exercises languages lib log notes public script spec test
do
  echo "chown/chgrp www-data ${folder}"
  eval "chown -R www-data $cyberDojoHome/$folder"
  eval "chgrp -R www-data $cyberDojoHome/$folder"
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
