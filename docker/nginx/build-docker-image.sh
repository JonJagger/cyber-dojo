#!/bin/bash

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${MY_DIR} > /dev/null
./../../public/build-docker-image.sh
EXIT_STATUS=$?
popd > /dev/null
exit ${EXIT_STATUS}

