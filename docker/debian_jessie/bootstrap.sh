#!/bin/bash

# Jessie = Debian 8

branch=https://raw.githubusercontent.com/JonJagger/cyber-dojo/runner-auto-cache/docker

curl -O ${branch}/debian_jessie/install_docker.sh
chmod +x install_docker.sh
install_docker.sh

docker pull cyberdojofoundation/gcc_assert

curl -O ${branch}/docker-compose.yml
curl -O ${branch}/debian_jessie/docker-compose.yml
curl -O ${branch}/debian_jessie/app_up.sh
chmod +x app_up.sh
./app_up.sh