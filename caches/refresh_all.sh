#!/bin/bash

cyberDojoHome=/var/www/cyber-dojo

echo "setting up the runner"
echo "..initializing bootstrap config file"
configFilename=$cyberDojoHome/config/cyber-dojo.json
chmod --silent 666 $configFilename
cp $cyberDojoHome/config/runner_bootstrap_config.json $configFilename
chmod 444 $configFilename
chown www-data:www-data $configFilename

$cyberDojoHome/lib/docker_runner_refresh.rb
$cyberDojoHome/lib/docker_machine_runner_refresh.rb

echo "setting up the exercises"
$cyberDojoHome/exercises/refresh_cache.rb

echo "setting up the languages"
$cyberDojoHome/languages/refresh_cache.rb
