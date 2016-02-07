#!/bin/bash

BRANCH=$1
OS=$2
# TODO: check $1

SCRIPTS=(install-docker-on-${OS}.sh)
SCRIPTS+=(docker-build-katas-image.sh)
SCRIPTS+=(docker-pull-common-languages.sh)
SCRIPTS+=(cyber-dojo-up.sh)

for SCRIPT in ${SCRIPTS[*]}
do
  curl -O ${BRANCH}/${SCRIPT}
  chmod +x ${SCRIPT}
done

# TODO: add readme.txt with info on installing new languages
FILES=(docker-compose.yml Dockerfile.katas .dockerignore.katas)
for FILE in ${FILES[*]}
do
  curl -O ${BRANCH}/${FILE}
done

for SCRIPT in ${SCRIPTS[*]}
do
  echo ${SCRIPT}
  #./${SCRIPT}
done