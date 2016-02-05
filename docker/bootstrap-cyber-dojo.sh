#!/bin/bash

# Installs docker and cyber-dojo onto a raw server.
# Use curl to get this file, chmod +x it, then run it.

BRANCH=https://raw.githubusercontent.com/JonJagger/cyber-dojo/runner-auto-cache/docker

# - - - - - - - - - - - - - - - - - - - - - - -
# katas/ is relative to /var/www/cyber-dojo folder
# to maintain backward compatibility

mkdir -p /var/www/cyber-dojo

# - - - - - - - - - - - - - - - - - - - - - - -
SCRIPTS=(cyber-dojo-up.sh)

OSES=(debian-jessie ubuntu-trusty)
for OS in ${OSES[*]}
do
  FILE=install-docker-on-${OS}.sh
  SCRIPTS+=($FILE)
done

for SCRIPT in ${SCRIPTS[*]}
do
  curl -O ${BRANCH}/${SCRIPT}
  chmod +x ${SCRIPT}
done

# - - - - - - - - - - - - - - - - - - - - - - -
CONFIG=docker-compose.yml
curl -O ${BRANCH}/${CONFIG}

# - - - - - - - - - - - - - - - - - - - - - - -
echo
echo 1. Install docker using one of
for OS in ${OSES[*]}
do
  echo "   $ ./install-docker-on-${OS}.sh "
done
echo

echo 2. Ensure at least one language container exists
echo '   $ docker pull cyberdojofoundation/gcc_assert'
echo

echo 3. Bring up cyber-dojo
echo '   $ ./cyber-dojo-up.sh'
echo
