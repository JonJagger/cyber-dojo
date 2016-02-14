#!/bin/sh
set -e

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
pushd ${MY_DIR} > /dev/null
./../../public/build-docker-image.sh
EXIT_STATUS=$?
popd > /dev/null
exit ${EXIT_STATUS}

