#!/bin/bash

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${MY_DIR} > /dev/null

mkdir -p /var/www/cyber-dojo/katas

ROOT=${1:-/usr/app/cyber-dojo}
CONTEXT_DIR=/var/www/cyber-dojo/katas

cp ./Dockerfile.katas ${CONTEXT_DIR}/Dockerfile
cp ./.dockerignore.katas ${CONTEXT_DIR}/.dockerignore

docker build \
  --build-arg=CYBER_DOJO_ROOT=${ROOT} \
  --tag=cyberdojofoundation/katas \
  --file=${CONTEXT_DIR}/Dockerfile \
  ${CONTEXT_DIR}

EXIT_STATUS=$?

rm ${CONTEXT_DIR}/Dockerfile
rm ${CONTEXT_DIR}/.dockerignore

popd > /dev/null

exit ${EXIT_STATUS}
