#!/bin/bash

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${MY_DIR} > /dev/null

CONTEXT_DIR=.

docker build \
  --build-arg=CYBER_DOJO_HOME=$1 \
  --tag=cyberdojofoundation/web \
  --file=${CONTEXT_DIR}/Dockerfile \
  ${CONTEXT_DIR}

EXIT_STATUS=$?

popd > /dev/null

exit ${EXIT_STATUS}
