#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${DIR} > /dev/null

docker build \
  --no-cache \
  --build-arg CYBER_DOJO_ROOT=$1 \
  --tag cyberdojofoundation/web \
  --file ./Dockerfile \
  ../../..

EXIT_STATUS=$?

popd > /dev/null

exit ${EXIT_STATUS}
