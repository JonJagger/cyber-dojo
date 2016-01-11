#!/bin/bash

# Run a local server using stub-runner to process [test] events.
# Good for quick exploratory style testing

configDir=/var/www/cyber-dojo/config

cp $configDir/stub-runner-cyber-dojo.json $configDir/cyber-dojo.json
rails s -e development
cp $configDir/default-cyber-dojo.json $configDir/cyber-dojo.json
