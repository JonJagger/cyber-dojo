#!/bin/bash

# Installs docker and cyber-dojo onto a raw Trusty (ubuntu 14.04) node.
# Use curl to get this file, chmod +x it, then run it.

branch=https://raw.githubusercontent.com/JonJagger/cyber-dojo/runner-auto-cache/docker/os/ubuntu_trusty

# Volumes are currently still relative to /var/www/cyber-dojo folder
# to maintain backward compatibility with
# /var/www/cyber-dojo/katas.

mkdir -p /var/www/cyber-dojo

curl -O ${branch}/install_docker.sh
curl -O ${branch}/app_up.sh
curl -O ${branch}/../docker-compose.yml

chmod +x install_docker.sh
chmod +x app_up.sh

# Hack: Ensure there is one language image so create page works
docker pull cyberdojofoundation/gcc_assert

echo
echo 'To (re)install docker'
echo '   $ ./install_docker.sh '
echo
echo 'To bring the cyber-dojo app up'
echo '   $ ./app_up.sh'
echo
