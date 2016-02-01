#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${DIR} > /dev/null

cp ../../../Gemfile .
docker build -t cyberdojofoundation/rails .
rm Gemfile

popd > /dev/null