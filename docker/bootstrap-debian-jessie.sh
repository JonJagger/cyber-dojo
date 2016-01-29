#!/bin/bash

# Jessie = Debian 8

branch=https://raw.githubusercontent.com/JonJagger/cyber-dojo/runner-auto-cache

curl -O ${branch}/docker/install_docker_on_debian_jessie.sh
curl -O ${branch}/docker/images/app-pull.sh
curl -O ${branch}/docker/docker-compose.debian-jessie.yml
curl -O ${branch}/docker/docker-compose.yml
curl -O ${branch}/docker/debian-jessie-up.sh

chmod +x install_docker_on_debian_jessie.sh
chmod +x app-pull.sh
chmod +x debian-jessie-up.sh

./install_docker_on_debian_jessie.sh
./app-pull.sh

docker pull cyberdojofoundation/gcc_assert

./debian-jessie-up.sh