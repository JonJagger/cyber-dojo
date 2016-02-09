#!/bin/bash

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${MY_DIR} > /dev/null

CONTEXT_DIR=.

docker build \
  --tag=cyberdojofoundation/nginx \
  --file=${CONTEXT_DIR}/Dockerfile \
  ${CONTEXT_DIR}

EXIT_STATUS=$?

popd > /dev/null

exit ${EXIT_STATUS}