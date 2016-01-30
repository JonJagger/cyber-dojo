#!/bin/bash

# update apt repository
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
#apt-get install -y apt-transport-https
apt-get update
apt-get purge lxc-docker
apt-cache policy docker-engine

# recommended
apt-get update
apt-get install linux-image-extra-$(uname -r)

# install docker
apt-get update
apt-get install -y docker-engine
service docker start

# install docker-machine
curl -L https://github.com/docker/machine/releases/download/v0.5.3/docker-machine_linux-amd64 >/usr/local/bin/docker-machine
chmod +x /usr/local/bin/docker-machine

# install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.6.0-rc2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
