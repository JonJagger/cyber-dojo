#!/bin/sh
set -e

CYBER_DOJO_HOME=$1
CYBER_DOJO_LANGUAGES_ROOT=${CYBER_DOJO_HOME}/app/languages

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

pushd ${MY_DIR} > /dev/null

# TODO: make cache.json file and copy it to ../../app/languages
#pushd ../../app/languages > /dev/null
#HOST_LANGUAGES_ROOT=${PWD}
#./write_cache.rb ${HOST_LANGUAGES_ROOT}
#popd > /dev/null

CONTEXT_DIR=../../app/languages

cp ./Dockerfile ${CONTEXT_DIR}

docker build \
  --build-arg=CYBER_DOJO_LANGUAGES_ROOT=${CYBER_DOJO_LANGUAGES_ROOT} \
  --tag=cyberdojofoundation/${PWD##*/} \
  --file=${CONTEXT_DIR}/Dockerfile \
  ${CONTEXT_DIR}

rm ${CONTEXT_DIR}/Dockerfile

popd > /dev/null
