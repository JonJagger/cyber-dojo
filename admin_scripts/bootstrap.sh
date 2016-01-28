#!/bin/bash

branch=https://raw.githubusercontent.com/JonJagger/cyber-dojo/runner-auto-cache

curl -O ${branch}/admin_scripts/install_docker_on_debian_jessie.sh
curl -O ${branch}/docker/pull-app-images.sh
curl -O ${branch}/docker/docker-compose.debian-jessie.yml
curl -O ${branch}/docker/docker-compose.yml

chmod +x install_docker_on_debian_jessie.sh
chmod +x pull-app-images.sh

./pull-app-images.sh
docker pull cyberdojofoundation/gcc_assert
docker-compose -f docker-compose.yml -f docker-compose.debian-jessie.yml up &