#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${DIR} > /dev/null

cp ./Dockerfile ../../../languages
pushd ../../../languages > /dev/null
docker build -t cyberdojofoundation/languages .
rm Dockerfile
popd > /dev/null

popd > /dev/null