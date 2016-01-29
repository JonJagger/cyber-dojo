#!/bin/bash

# Jessie = Debian 8

branch=https://raw.githubusercontent.com/JonJagger/cyber-dojo/runner-auto-cache/docker

curl -O ${branch}/install_docker_on_debian_jessie.sh
curl -O ${branch}/docker-compose.debian_jessie.yml
curl -O ${branch}/docker-compose.yml
curl -O ${branch}/debian_jessie_up.sh

chmod +x install_docker_on_debian_jessie.sh
./install_docker_on_debian_jessie.sh

docker pull cyberdojofoundation/gcc_assert

chmod +x debian_jessie_up.sh
./debian_jessie_up.sh