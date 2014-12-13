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

apt-get install -y acl

# cyber-dojo creates folders under katas
echo "chown/chgrp www-data katas"
chmod g+rwsx katas
setfacl -d -m group:www-data:rwx $cyberDojoHome/katas
setfacl -m group:www-data:rwx $cyberDojoHome/katas

# ensure pulled files have correct rights
for folder in app config exercises languages lib log notes public script spec test
do
  echo "chown/chgrp www-data ${folder}"
  chown -R www-data $cyberDojoHome/$folder
  chgrp -R www-data $cyberDojoHome/$folder
done

# tests create folders under tests/cyberdojo/katas
echo "chown/chgrp www-data test/cyberdojo"
chmod g+rwsx $cyberDojoHome/test/cyberdojo
setfacl -d -m group:www-data:rwx $cyberDojoHome/test/cyberdojo
setfacl -m group:www-data:rwx $cyberDojoHome/test/cyberdojo

echo "chown/chgrp www-data *"
chown www-data $cyberDojoHome/*
chgrp www-data $cyberDojoHome/*

echo "chown/chgrp www-data .*"
chown www-data $cyberDojoHome/.*
chgrp www-data $cyberDojoHome/.*

echo "chown/chgrp www-data tmp/cache"
rm -rf tmp/cache
mkdir -p tmp/cache
chown www-data $cyberDojoHome/tmp/cache
chgrp www-data $cyberDojoHome/tmp/cache

echo "refreshing exercises/ cache"
$cyberDojoHome/exercises/cache.rb

echo "refreshing languages/ cache"
$cyberDojoHome/languages/cache.rb

echo "poking rails"
bundle install

echo "restarting apache"
service apache2 restart
