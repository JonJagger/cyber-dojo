#!/bin/bash

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${MY_DIR} > /dev/null

DIR=${PWD##*/}
CONTEXT_DIR=.

docker build \
  --tag=cyberdojofoundation/${DIR} \
  --file=${CONTEXT_DIR}/Dockerfile \
    ${CONTEXT_DIR}

EXIT_STATUS=$?

popd > /dev/null

exit ${EXIT_STATUS}