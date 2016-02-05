#!/bin/bash

# Installs docker and cyber-dojo onto a raw Jessie (Debian 8) node.
# Use curl to get this file, chmod +x it, then run it.

branch=https://raw.githubusercontent.com/JonJagger/cyber-dojo/runner-auto-cache/docker/os/debian_jessie

# Volumes are currently still relative to /var/www/cyber-dojo folder
# to maintain backward compatibility with
# /var/www/cyber-dojo/katas.

mkdir -p /var/www/cyber-dojo

curl -O ${branch}/install_docker.sh
curl -O ${branch}/app_up.sh
curl -O ${branch}/../docker-compose.yml

chmod +x install_docker.sh
chmod +x app_up.sh

echo
echo 1. Install docker
echo '   $ ./install_docker.sh '
echo
echo 2. Ensure at least one language container exists
echo '   $ docker pull cyberdojofoundation/gcc_assert'
echo
echo 3. Bring up cyber-dojo
echo '   $ ./app_up.sh'
echo
