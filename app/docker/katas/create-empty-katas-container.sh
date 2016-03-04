#!/bin/sh
set -e

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

pushd ${MY_DIR} > /dev/null

# This has to be the same as KATAS_DEFAULT in docker/cyber-dojo script
CYBER_DOJO_KATAS_ROOT=/usr/src/cyber-dojo/katas

./build-image.sh ${CYBER_DOJO_KATAS_ROOT}

popd > /dev/null
