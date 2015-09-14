#!/bin/bash
# Use once to set the rights to www-data

cyberDojoHome=/var/www/cyber-dojo
cd $cyberDojoHome

apt-get install -y acl

# cyber-dojo creates folders under katas
echo "chown/chgrp www-data katas"
chmod g+rwsx katas
setfacl -d -m group:www-data:rwx $cyberDojoHome/katas
setfacl -m group:www-data:rwx $cyberDojoHome/katas

# ensure pulled files have correct rights
for folder in admin_scripts app config exercises languages lib log notes public script spec test
do
  echo "chown www-data:www-data ${folder}"
  chown -R www-data:www-data $cyberDojoHome/$folder
done

# tests create folders under tests/cyber-dojo/katas
echo "chown www-data test/cyber-dojo"
chmod g+rwsx $cyberDojoHome/test/cyber-dojo
setfacl -d -m group:www-data:rwx $cyberDojoHome/test/cyber-dojo
setfacl -m group:www-data:rwx $cyberDojoHome/test/cyber-dojo

echo "chown www-data:www-data *"
chown www-data:www-data $cyberDojoHome/*

echo "chown www-data:www-data .*"
chown www-data:www-data $cyberDojoHome/.*

echo "chown -R www-data:www-data tmp"
chown -R www-data:www-data $cyberDojoHome/tmp

