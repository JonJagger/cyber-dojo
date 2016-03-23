#!/bin/sh
set -e

# These commands are copied directly from the docker website.
# This script is part of the server installation instructions
# described at http://blog.cyber-dojo.org/2016/03/running-your-own-cyber-dojo-server.html

echo 'installing docker'
curl -sSL https://get.docker.com/ | sh

echo 'installing docker-machine'
curl -L https://github.com/docker/machine/releases/download/v0.6.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine
chmod +x /usr/local/bin/docker-machine

echo 'installing docker-compose'
curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
