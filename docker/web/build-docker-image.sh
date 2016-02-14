#!/bin/sh
set -e

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
pushd ${MY_DIR} > /dev/null
./../../build-docker-image.sh $1
EXIT_STATUS=$?
popd > /dev/null
exit ${EXIT_STATUS}
