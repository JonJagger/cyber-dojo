#!/bin/bash

# install docker
apt-get purge lxc-docker*
apt-get purge docker.io*
# not using pgp.mit.edu because its sometimes been flaky
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list
apt-get install -y apt-transport-https
apt-get update
apt-cache policy docker-engine

apt-get install -y docker-engine
curl -L https://github.com/docker/machine/releases/download/v0.4.0/docker-machine_linux-amd64 > /usr/local/bin/docker-machine
chmod +x /usr/local/bin/docker-machine

gpasswd -a www-data docker
service docker restart

# install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.6.0-rc1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
