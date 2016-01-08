#!/bin/bash

cyberDojoHome=/var/www/cyber-dojo

echo "refreshing runners"
configFilename=$cyberDojoHome/config/cyber-dojo.json
cp $cyberDojoHome/config/bootstrap.cyber-dojo.json $configFilename
chmod 444 $configFilename
chown www-data:www-data $configFilename

$cyberDojoHome/lib/docker_runner_refresh.rb
$cyberDojoHome/lib/docker_machine_runner_refresh.rb

echo "refreshing exercises cache"
$cyberDojoHome/exercises/refresh_cache.rb

echo "refreshing languages cache"
$cyberDojoHome/languages/refresh_cache.rb
