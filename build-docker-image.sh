#!/bin/bash

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${MY_DIR} > /dev/null

ROOT=${1:-/usr/app/cyber-dojo}
CONTEXT_DIR=.

docker build \
  --build-arg=CYBER_DOJO_ROOT=${ROOT} \
  --tag=cyberdojofoundation/web \
  --file=${CONTEXT_DIR}/Dockerfile \
  ${CONTEXT_DIR}

EXIT_STATUS=$?

popd > /dev/null

exit ${EXIT_STATUS}
