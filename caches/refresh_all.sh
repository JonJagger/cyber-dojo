#!/bin/bash

cyberDojoHome=/var/www/cyber-dojo/

echo "setting up the runner"
echo "..initializing bootstrap config file"
configFilename=$cyberDojoHome/config/cyber-dojo.json
chmod --silent 666 $configFilename
cp $cyberDojoHome/config/runner_bootstrap_config.json $configFilename
chmod 444 $configFilename

$cyberDojoHome/lib/docker_runner_refresh.rb
$cyberDojoHome/lib/docker_machine_runner_refresh.rb
