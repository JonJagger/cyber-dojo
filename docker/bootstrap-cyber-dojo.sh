#!/bin/bash

BRANCH=$1
OS=$2
# TODO: validate $1

FILES=(docker-compose.yml)
# TODO: FILES+=(installing-more-languages-readme.txt)
for FILE in ${FILES[*]}
do
  curl -O ${BRANCH}/${FILE}
done

SCRIPTS=(install-docker-on-${OS}.sh)
#SCRIPTS+=(move-katas-folder.sh)
SCRIPTS+=(docker-pull-common-languages.sh)
SCRIPTS+=(cyber-dojo-up.sh)

for SCRIPT in ${SCRIPTS[*]}
do
  curl -O ${BRANCH}/${SCRIPT}
  chmod +x ${SCRIPT}
  ./${SCRIPT}
done
