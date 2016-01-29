#!/bin/bash

# Trust = Ubuntu 14.04

branch=https://raw.githubusercontent.com/JonJagger/cyber-dojo/runner-auto-cache/docker

curl -O ${branch}/install_docker_on_ubuntu_trusty.sh
curl -O ${branch}/images/app_pull.sh
curl -O ${branch}/docker-compose.ubuntu_trusty.yml
curl -O ${branch}/docker-compose.yml
curl -O ${branch}/ubuntu_trusty_up.sh

chmod +x install_docker_on_ubuntu_trusty.sh
chmod +x app_pull.sh
chmod +x ubuntu_trusty_up.sh

./install_docker_on_ubuntu_trusty.sh
./app_pull.sh

docker pull cyberdojofoundation/gcc_assert

./ubuntu_trusty_up.sh