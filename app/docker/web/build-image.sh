#!/bin/bash
set -e

# A docker-client binary is installed *inside* the web image
# This creates a dependency on the docker-version installed
# on the host. Thus, the web Dockerfile accepts the docker-version
# to install as a parameter, and the built web image is tagged with
# this version number.
DOCKER_VERSION=${1:-1.11.1}

# the 'home' directory inside the web image. I don't expect
# this to change, it's parameterized to avoid duplication.
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
