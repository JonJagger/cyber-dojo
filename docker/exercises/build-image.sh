#!/bin/sh
set -e

CYBER_DOJO_HOME=$1
CYBER_DOJO_EXERCISES_ROOT=${CYBER_DOJO_HOME}/app/exercises

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

pushd ${MY_DIR} > /dev/null

# TODO: make cache.json file and copy it to ../../app/exercises
#pushd ../../app/exercises > /dev/null
#HOST_EXERCISES_ROOT=${PWD}
#./write_cache.rb ${HOST_EXERCISES_ROOT}
#popd > /dev/null

CONTEXT_DIR=../../app/exercises

cp ./Dockerfile ${CONTEXT_DIR}

docker build \
  --build-arg=CYBER_DOJO_EXERCISES_ROOT=${CYBER_DOJO_EXERCISES_ROOT} \
  --tag=cyberdojofoundation/${PWD##*/} \
  --file=${CONTEXT_DIR}/Dockerfile \
  ${CONTEXT_DIR}

rm ${CONTEXT_DIR}/Dockerfile

popd > /dev/null
