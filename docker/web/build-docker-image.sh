#!/bin/sh
set -e

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

pushd ${MY_DIR} > /dev/null

CONTEXT_DIR=../..

cp ./Dockerfile ${CONTEXT_DIR}
cp ./.dockerignore ${CONTEXT_DIR}

docker build \
  --build-arg=CYBER_DOJO_HOME=$1 \
  --tag=cyberdojofoundation/web \
  --file=${CONTEXT_DIR}/Dockerfile \
  ${CONTEXT_DIR}

rm ${CONTEXT_DIR}/Dockerfile
rm ${CONTEXT_DIR}/.dockerignore

popd > /dev/null
