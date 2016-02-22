#!/bin/sh

CYBER_DOJO_HOME=$1

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

pushd ${MY_DIR} > /dev/null

pushd ../../app/exercises > /dev/null
HOST_EXERCISES_ROOT=${PWD}
./write_cache.rb ${HOST_EXERCISES_ROOT}
popd > /dev/null

./build-image.sh ${CYBER_DOJO_HOME}

CONTAINER_NAME=cyber-dojo-exercises
docker rm -f ${CONTAINER_NAME}

docker run --name ${CONTAINER_NAME} cyberdojofoundation/exercises echo 'exercises-data-container'

popd > /dev/null
