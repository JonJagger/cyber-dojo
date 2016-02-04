#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${DIR} > /dev/null

docker build \
  --tag cyberdojofoundation/nginx \
  --file ./Dockerfile \
  ../../..

EXIT_STATUS=$?

popd > /dev/null

exit ${EXIT_STATUS}