#!/bin/bash

# Brings up cyber-dojo after running bootstrap.sh
# which puts both .yml files into the same folder.
# Port 80 must be open.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${DIR} > /dev/null

CYBER_DOJO_ROOT=${1:-/var/www/cyber-dojo}
export CYBER_DOJO_ROOT=${CYBER_DOJO_ROOT}
CYBER_DOJO_MODE=${2:-production}
export CYBER_DOJO_MODE=${CYBER_DOJO_MODE}

docker-compose \
  --file docker-compose.yml \
  --file docker-compose.ubuntu_trusty.yml \
  up &

popd > /dev/null
