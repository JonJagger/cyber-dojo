#!/bin/bash

# Installs the latest cyber-dojo.
# Also updates docker containers.

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

# cyber-dojo creates folders under katas
apt-get install -y acl
echo "chown/chgrp www-data katas"
chmod g+rwsx katas
setfacl -d -m group:www-data:rwx $cyberDojoHome/katas
setfacl -m group:www-data:rwx $cyberDojoHome/katas

# ensure all folders have correct rights
folders=(admin_scripts app caches config coverage exercises languages lib log notes public script spec test tmp)
for folder in ${folders[*]}
do
  echo "chown www-data:www-data ${folder}"
  chown -R www-data:www-data $cyberDojoHome/$folder
done

# ensure all files have correct rights
echo "chown www-data:www-data *"
chown www-data:www-data $cyberDojoHome/*

echo "chown www-data:www-data .*"
chown www-data:www-data $cyberDojoHome/.*

# - - - - - - - - - - - - - - - - - - - - - - - - -
# do bundle-install before refreshing the caches
# in case there is a new dependenciy (eg open4)

echo "deleting the rails cache"
rm -rf $cyberDojoHome/tmp/*

echo "poking rails"
rm $cyberDojoHome/Gemfile.lock
bundle install

# - - - - - - - - - - - - - - - - - - - - - - - - -
# refresh caches

echo "refreshing languages cache"
$cyberDojoHome/languages/refresh_cache.rb

echo "refreshing exercises cache/"
$cyberDojoHome/exercises/refresh_cache.rb

if docker --version > /dev/null 2>&1; then
  echo "docker is installed"
  echo "refreshing DockerRunner cache"
  $cyberDojoHome/lib/refresh_docker_runner_cache.rb
else
  echo "docker is NOT installed!!"
fi

if docker-machine --version > /dev/null 2>&1; then
  echo "docker-machine is installed"
  echo "refreshing DockerMachineRunner cache"
  $cyberDojoHome/lib/refresh_docker_machine_runner_cache.rb
else
  echo "docker-machine is NOT installed"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - -
echo "restarting apache"
service apache2 restart

# - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "$MY_TIME_STAMP_BEFORE" != "$MY_TIME_STAMP_AFTER" ]; then
  echo ">>>>>>>>> ALERT <<<<<<<<<"
  echo "$0 updated itself!!!"
  echo "consider running it again"
  echo ">>>>>>>>> ALERT <<<<<<<<<"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - -
echo
echo "If something went wrong you can revert to the previous version."
echo "$ git checkout $GIT_SHA1_BEFORE"
echo "$ service apache2 restart"
echo
