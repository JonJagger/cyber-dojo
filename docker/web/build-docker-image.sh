#!/bin/bash

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${MY_DIR} > /dev/null
./../../build-docker-image.sh $1
EXIT_STATUS=$?
popd > /dev/null
exit ${EXIT_STATUS}
