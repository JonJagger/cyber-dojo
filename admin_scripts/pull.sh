#!/bin/bash

# Installs the latest cyber-dojo.
# Does *not* install docker containers.
# For that use
#   $ /var/www/cyber-dojo/admin_scripts/docker_pull_all.sh
# or
#   $ /var/www/cyber-dojo/admin_scripts/docker_update_all.sh

cyberDojoHome=/var/www/cyber-dojo
cd $cyberDojoHome

# store the sha1 of the commit before the update
GIT_SHA1_BEFORE=`git rev-parse --verify HEAD`

# store the time-stamp of this file before doing git-pull
MY_TIME_STAMP_BEFORE=`stat -c %y $cyberDojoHome/admin_scripts/pull.sh`

# get latest source
echo "git pulling from https://github.com/JonJagger/cyber-dojo"
cd $cyberDojoHome
git pull --no-edit origin master
ret=$?
if [ $ret -ne 0 ]; then
  exit
fi

# store the time-stamp of this file after the git-pull
MY_TIME_STAMP_AFTER=`stat -c %y $cyberDojoHome/admin_scripts/pull.sh`

apt-get install -y acl

# cyber-dojo creates folders under katas
echo "chown/chgrp www-data katas"
chmod g+rwsx katas
setfacl -d -m group:www-data:rwx $cyberDojoHome/katas
setfacl -m group:www-data:rwx $cyberDojoHome/katas

# ensure all files have correct rights
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

echo "deleting the rails cache"
rm -rf $cyberDojoHome/tmp/*

echo "refreshing the languages/ cache"
$cyberDojoHome/languages/cache.rb

echo "refreshing the exercises/ cache"
$cyberDojoHome/exercises/cache.rb

echo "poking rails"
bundle install

echo "restarting apache"
service apache2 restart

if [ "$MY_TIME_STAMP_BEFORE" != "$MY_TIME_STAMP_AFTER" ]; then
  echo ">>>>>>>>> ALERT <<<<<<<<<"
  echo "$0 updated itself!!!"
  echo "consider running it again"
  echo ">>>>>>>>> ALERT <<<<<<<<<"
fi

echo
echo "If something went wrong you can revert to the previous version."
echo "$ git checkout $GIT_SHA1_BEFORE"
echo
