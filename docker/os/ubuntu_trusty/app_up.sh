#!/bin/bash

# Brings up cyber-dojo after running bootstrap.sh
# which puts both .yml files into the same folder.
# Port 80 must be open.

if [ -z "$1" ]; then
  echo "./app_up.sh  <CYBER_DOJO_ROOT>"
  exit
fi
export CYBER_DOJO_ROOT=${1}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${DIR} > /dev/null

docker-compose \
  --file docker-compose.yml \
  --file docker-compose.ubuntu_trusty.yml \
  up &

popd > /dev/null
