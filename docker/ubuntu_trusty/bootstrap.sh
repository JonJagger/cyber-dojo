#!/bin/bash

# Trust = Ubuntu 14.04

branch=https://raw.githubusercontent.com/JonJagger/cyber-dojo/runner-auto-cache/docker

curl -O ${branch}/ubuntu_trusty/install_docker.sh
chmod +x install_docker.sh
./install_docker.sh

docker pull cyberdojofoundation/gcc_assert

curl -O ${branch}/docker-compose.yml
curl -O ${branch}/ubuntu_trusty/docker-compose.yml
curl -O ${branch}/ubuntu_trusty/app_up.sh
chmod +x app_up.sh
./app_up.sh