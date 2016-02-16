#!/bin/sh
set -e

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

pushd ${MY_DIR} > /dev/null
./build-image.sh /usr/src/cyber-dojo/app/katas
popd > /dev/null
