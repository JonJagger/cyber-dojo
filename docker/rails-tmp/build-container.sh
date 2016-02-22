#!/bin/sh

CYBER_DOJO_HOME=$1

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

pushd ${MY_DIR} > /dev/null

./build-image.sh ${CYBER_DOJO_HOME}

CONTAINER_NAME=cyber-dojo-rails-tmp
docker rm -f ${CONTAINER_NAME}

docker run --name ${CONTAINER_NAME} cyberdojofoundation/rails-tmp echo 'rails-tmp-data-container'

popd > /dev/null
