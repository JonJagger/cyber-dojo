#!/bin/bash

cyberDojoHome=/var/www/cyber-dojo

echo "refreshing exercises cache/"
$cyberDojoHome/exercises/refresh_cache.rb

echo "refreshing languages cache"
$cyberDojoHome/languages/refresh_cache.rb

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



