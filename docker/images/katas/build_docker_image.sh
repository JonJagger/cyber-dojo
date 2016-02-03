#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${DIR} > /dev/null
cp ./Dockerfile ../../../katas
pushd ../../../katas > /dev/null

docker build \
  --no-cache \
  --build-arg CYBER_DOJO_ROOT=$1 \
  --tag cyberdojofoundation/katas \
  --file ./Dockerfile \
  .

EXIT_STATUS=$?

rm Dockerfile
popd > /dev/null
popd > /dev/null

exit ${EXIT_STATUS}