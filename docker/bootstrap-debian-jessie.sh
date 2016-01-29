#!/bin/bash

# Jessie = Debian 8

branch=https://raw.githubusercontent.com/JonJagger/cyber-dojo/runner-auto-cache

curl -O ${branch}/docker/install_docker_on_debian_jessie.sh
curl -O ${branch}/docker/pull-app-images.sh
curl -O ${branch}/docker/docker-compose.debian-jessie.yml
curl -O ${branch}/docker/docker-compose.yml
curl -O ${branch}/docker/up-debian-jessie.sh

chmod +x install_docker_on_debian_jessie.sh
chmod +x pull-app-images.sh
chmod +x up-debian-jessie.sh

./install_docker_on_debian_jessie.sh
./pull-app-images.sh

docker pull cyberdojofoundation/gcc_assert

./up-debian-jessie.sh