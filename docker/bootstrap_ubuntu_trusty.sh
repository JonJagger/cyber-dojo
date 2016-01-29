#!/bin/bash

# Trust = Ubuntu 14.04

branch=https://raw.githubusercontent.com/JonJagger/cyber-dojo/runner-auto-cache/docker

curl -O ${branch}/install_docker_on_ubuntu_trusty.sh
curl -O ${branch}/docker-compose.ubuntu_trusty.yml
curl -O ${branch}/docker-compose.yml
curl -O ${branch}/ubuntu_trusty_up.sh

chmod +x install_docker_on_ubuntu_trusty.sh
./install_docker_on_ubuntu_trusty.sh

docker pull cyberdojofoundation/gcc_assert

chmod +x ubuntu_trusty_up.sh
./ubuntu_trusty_up.sh