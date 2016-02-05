#!/bin/bash

# Installs docker and cyber-dojo onto a raw server.
# Use curl to get this file, chmod +x it, then run it.

BRANCH=https://raw.githubusercontent.com/JonJagger/cyber-dojo/runner-auto-cache/images

# - - - - - - - - - - - - - - - - - - - - - - -
# katas/ is relative to /var/www/cyber-dojo folder
# to maintain backward compatibility with
# /var/www/cyber-dojo/katas.
mkdir -p /var/www/cyber-dojo

# - - - - - - - - - - - - - - - - - - - - - - -
OSES=(debian-jessie ubuntu-trusty)
for OS in ${OSES[*]}
do
  FILE=install-docker-on-${OS}.sh
  curl -O ${BRANCH}/${FILE}
  chmod +x ${FILE}
done

# - - - - - - - - - - - - - - - - - - - - - - -
FILES=(cyber-dojo-up.sh docker-compose.yml)
for FILE in ${FILES[*]}
do
  curl -O ${BRANCH}/${FILE}
  chmod +x ${FILE}
done

# - - - - - - - - - - - - - - - - - - - - - - -
echo
echo 1. Install docker using one of
for OS in ${OSES[*]}
do
  echo '   $ ./install-docker-on-${OS}.sh '
done
echo

echo 2. Ensure at least one language container exists
echo '   $ docker pull cyberdojofoundation/gcc_assert'
echo

echo 3. Bring up cyber-dojo
echo '   $ ./cyber-dojo-up.sh'
echo
