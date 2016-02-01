#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${DIR} > /dev/null

docker build \
  -t cyberdojofoundation/web \
  -f ./Dockerfile \
  ../../..

popd > /dev/null