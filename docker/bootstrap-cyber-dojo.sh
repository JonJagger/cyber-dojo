#!/bin/bash

BRANCH=$1
OS=$2
# TODO: validate $1

FILE=docker-compose.yml
curl -O ${BRANCH}/${FILE}

# TODO: FILE=installing-more-languages-readme.txt

SCRIPT=install-docker-on-${OS}.sh
curl -O ${BRANCH}/${SCRIPT}
chmod +x ${SCRIPT}
./${SCRIPT}

SCRIPT=docker-pull-common-languages.sh
curl -O ${BRANCH}/${SCRIPT}
chmod +x ${SCRIPT}
./${SCRIPT}

SCRIPT=cyber-dojo-up.sh
curl -O ${BRANCH}/${SCRIPT}
chmod +x ${SCRIPT}

# Put info on making this call on the blog page
#./${SCRIPT} --katas=....