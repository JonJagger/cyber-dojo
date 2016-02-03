#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${DIR} > /dev/null
cp ../../../Gemfile .

docker build \
  --no-cache \
  --build-arg CYBER_DOJO_ROOT=$1 \
  --tag cyberdojofoundation/rails \
  --file ./Dockerfile \
  .

EXIT_STATUS=$?

rm Gemfile
popd > /dev/null

exit ${EXIT_STATUS}