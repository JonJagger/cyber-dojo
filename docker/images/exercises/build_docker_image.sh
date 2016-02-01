#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${DIR} > /dev/null

cp ./Dockerfile ../../../exercises
pushd ../../../exercises > /dev/null
docker build -t cyberdojofoundation/exercises .
rm Dockerfile
popd > /dev/null

popd > /dev/null