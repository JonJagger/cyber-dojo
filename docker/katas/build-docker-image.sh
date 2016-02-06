#!/bin/bash

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${MY_DIR} > /dev/null

ROOT=${1:-/var/www/cyber-dojo}
DIR=katas
CONTEXT_DIR=./../../${DIR}
CONFIG_FILES=(Dockerfile)

for CONFIG_FILE in ${CONFIG_FILES[*]}
do
  cp ./${CONFIG_FILE} ${CONTEXT_DIR}
done

docker build \
  --build-arg=CYBER_DOJO_ROOT=${ROOT} \
  --tag=cyberdojofoundation/${DIR} \
  --file=${CONTEXT_DIR}/Dockerfile \
  ${CONTEXT_DIR}

EXIT_STATUS=$?

for CONFIG_FILE in ${CONFIG_FILES[*]}
do
  rm ${CONTEXT_DIR}/${CONFIG_FILE}
done

popd > /dev/null

exit ${EXIT_STATUS}
