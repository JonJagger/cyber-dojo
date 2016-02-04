#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${DIR} > /dev/null
cp ./Dockerfile ../../../test
pushd ../../../test > /dev/null

docker build \
  --build-arg CYBER_DOJO_ROOT=$1 \
  --tag cyberdojofoundation/test \
  --file ./Dockerfile \
  .

EXIT_STATUS=$?

rm Dockerfile
popd > /dev/null
popd > /dev/null

exit ${EXIT_STATUS}