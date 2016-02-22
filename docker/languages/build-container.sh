#!/bin/sh

CYBER_DOJO_HOME=$1

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

pushd ${MY_DIR} > /dev/null

pushd ../../app/languages > /dev/null
HOST_LANGUAGES_ROOT=${PWD}
./write_cache.rb ${HOST_LANGUAGES_ROOT}
popd > /dev/null

./build-image.sh ${CYBER_DOJO_HOME}

CONTAINER_NAME=cyber-dojo-languages
docker rm -f ${CONTAINER_NAME}

docker run --name ${CONTAINER_NAME} cyberdojofoundation/languages echo 'languages-data-container'

popd > /dev/null
