#!/bin/sh
set -e

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
CONTEXT_DIR=.

pushd ${MY_DIR} > /dev/null

docker build \
  --tag=cyberdojofoundation/${PWD##*/} \
  --file=${CONTEXT_DIR}/Dockerfile \
  ${CONTEXT_DIR}

popd > /dev/null
