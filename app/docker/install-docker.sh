#!/bin/sh
set -e

# These commands are from the docker website.
# This script is part of the server installation instructions
# described at http://blog.cyber-dojo.org/2016/03/running-your-own-cyber-dojo-server.html

echo 'installing docker'
curl -sSL https://get.docker.com/ | sh

echo 'installing docker-machine 0.6.0'
curl -L https://github.com/docker/machine/releases/download/v0.6.0/docker-machine-`uname -s`-`uname -m` > docker-machine
mv docker-machine /usr/local/bin/docker-machine
chmod +x /usr/local/bin/docker-machine

echo 'installing docker-compose 1.7.0'
curl -L https://github.com/docker/compose/releases/download/1.7.0/docker-compose-`uname -s`-`uname -m` > docker-compose
mv docker-compose /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
