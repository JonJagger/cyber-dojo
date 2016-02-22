#!/bin/sh

CYBER_DOJO_HOME=$1

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

pushd ${MY_DIR} > /dev/null

./build-image.sh ${CYBER_DOJO_HOME}

CONTAINER_NAME=cyber-dojo-rails-log
docker rm -f ${CONTAINER_NAME}

docker run --name ${CONTAINER_NAME} cyberdojofoundation/rails-log echo 'rails-log-data-container'

popd > /dev/null
