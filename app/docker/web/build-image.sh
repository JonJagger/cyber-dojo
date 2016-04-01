#!/bin/bash
set -e

DOCKER_VERSION=${1:-1.10.3}
CYBER_DOJO_HOME=${2:-/usr/src/cyber-dojo}

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

pushd ${MY_DIR} > /dev/null

CONTEXT_DIR=../../..

cp ./Dockerfile    ${CONTEXT_DIR}
cp ./.dockerignore ${CONTEXT_DIR}

docker build \
  --build-arg=CYBER_DOJO_HOME=${CYBER_DOJO_HOME} \
  --build-arg=DOCKER_VERSION=${DOCKER_VERSION} \
  --tag=cyberdojofoundation/${PWD##*/}:${DOCKER_VERSION} \
  --file=${CONTEXT_DIR}/Dockerfile \
  ${CONTEXT_DIR}

rm ${CONTEXT_DIR}/Dockerfile
rm ${CONTEXT_DIR}/.dockerignore

popd > /dev/null
