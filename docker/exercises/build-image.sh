#!/bin/sh
set -e

CYBER_DOJO_HOME=$1

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

pushd ${MY_DIR} > /dev/null

CONTEXT_DIR=../../app/exercises

cp ./Dockerfile ${CONTEXT_DIR}

docker build \
  --build-arg=CYBER_DOJO_HOME=${CYBER_DOJO_HOME} \
  --tag=cyberdojofoundation/${PWD##*/} \
  --file=${CONTEXT_DIR}/Dockerfile \
  ${CONTEXT_DIR}

rm ${CONTEXT_DIR}/Dockerfile

popd > /dev/null
