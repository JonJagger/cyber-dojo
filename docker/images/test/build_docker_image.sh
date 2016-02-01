#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${DIR} > /dev/null

cp ./Dockerfile ../../../test
pushd ../../../test > /dev/null
docker build -t cyberdojofoundation/test -f ./Dockerfile .
rm Dockerfile
popd > /dev/null

popd > /dev/null
