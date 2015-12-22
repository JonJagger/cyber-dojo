#!/bin/bash

cyberDojoHome=/var/www/cyber-dojo

echo "refreshing exercises cache"
$cyberDojoHome/exercises/refresh_cache.rb

echo "refreshing languages cache"
$cyberDojoHome/languages/refresh_cache.rb

echo "refreshing runners caches"
$cyberDojoHome/lib/refresh_docker_runner_cache.rb
$cyberDojoHome/lib/refresh_docker_machine_runner_cache.rb


