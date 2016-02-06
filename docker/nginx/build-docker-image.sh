#!/bin/bash

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${MY_DIR} > /dev/null

CONTEXT_DIR=./../../public
CONFIG_FILES=(nginx.conf Dockerfile .dockerignore)

for CONFIG_FILE in ${CONFIG_FILES[*]}
do
  cp ./${CONFIG_FILE} ${CONTEXT_DIR}
done

docker build \
  --tag=cyberdojofoundation/nginx \
  --file=${CONTEXT_DIR}/Dockerfile \
  ${CONTEXT_DIR}

EXIT_STATUS=$?

for CONFIG_FILE in ${CONFIG_FILES[*]}
do
  rm ${CONTEXT_DIR}/${CONFIG_FILE}
done

popd > /dev/null

exit ${EXIT_STATUS}