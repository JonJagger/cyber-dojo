#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${DIR} > /dev/null
cp ./Dockerfile ../../../languages
pushd ../../../languages > /dev/null

docker build \
  --no-cache \
  --build-arg CYBER_DOJO_ROOT=$1 \
  --tag cyberdojofoundation/languages \
  --file ./Dockerfile \
  .

EXIT_STATUS=$?

rm Dockerfile
popd > /dev/null
popd > /dev/null

exit ${EXIT_STATUS}