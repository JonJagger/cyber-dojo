#!/bin/bash

# https://raw.githubusercontent.com/JonJagger/cyber-dojo/runner-auto-cache/docker/install-cyber-dojo-on-debian-jessie.sh
# Use curl to get this file, chmod +x it, then run it.

BRANCH=https://raw.githubusercontent.com/JonJagger/cyber-dojo/runner-auto-cache/docker
FILE=bootstrap-cyber-dojo.sh

curl -O ${BRANCH}/${FILE}
chmod +x ${FILE}
./${FILE} ${BRANCH} debian-jessie
