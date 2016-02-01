#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${DIR} > /dev/null

cp ./Dockerfile ../../../katas
pushd ../../../katas > /dev/null
docker build -t cyberdojofoundation/katas .
rm Dockerfile
popd > /dev/null

popd > /dev/null
