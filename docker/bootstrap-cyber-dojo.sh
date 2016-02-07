#!/bin/bash

# Installs docker and cyber-dojo onto a raw server.
# Use curl to get this file, chmod +x it, then run it.

BRANCH=https://raw.githubusercontent.com/JonJagger/cyber-dojo/runner-auto-cache/docker
OSES=(debian-jessie ubuntu-trusty)
SCRIPTS=(cyber-dojo-up.sh build-katas-image.sh)

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
CONFIG_FILES=(docker-compose.yml Dockerfile.katas .dockerignore.katas instructions.txt)
for CONFIG_FILE in ${CONFIG_FILES[*]}
do
  curl -O ${BRANCH}/${CONFIG_FILE}
done

cat instructions.txt
