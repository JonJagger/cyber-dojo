#!/bin/bash

cyberDojoHome=/var/www/cyber-dojo

echo "setting up the runner"
echo "..setting config/bootstrap_config.json"
configFilename=$cyberDojoHome/config/cyber-dojo.json
cp $cyberDojoHome/config/runner_bootstrap_config.json $configFilename
chmod 444 $configFilename
chown www-data:www-data $configFilename

$cyberDojoHome/lib/docker_runner_refresh.rb
$cyberDojoHome/lib/docker_machine_runner_refresh.rb

echo "setting up the exercises"
$cyberDojoHome/exercises/refresh_cache.rb

echo "setting up the languages"
$cyberDojoHome/languages/refresh_cache.rb
