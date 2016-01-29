#!/bin/bash

# Jessie = Debian 8

branch=https://raw.githubusercontent.com/JonJagger/cyber-dojo/runner-auto-cache

curl -O ${branch}/docker/install_docker_on_debian_jessie.sh
curl -O ${branch}/docker/images/app_pull.sh
curl -O ${branch}/docker/docker-compose.debian_jessie.yml
curl -O ${branch}/docker/docker-compose.yml
curl -O ${branch}/docker/debian_jessie_up.sh

chmod +x install_docker_on_debian_jessie.sh
chmod +x app_pull.sh
chmod +x debian_jessie_up.sh

./install_docker_on_debian_jessie.sh
./app_pull.sh

docker pull cyberdojofoundation/gcc_assert

./debian_jessie_up.sh