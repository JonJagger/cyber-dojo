#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${DIR} > /dev/null

export CYBER_DOJO_ROOT=${1:-/var/www/cyber-dojo}
export CYBER_DOJO_UP=${2:-production}

docker-compose \
  --file docker-compose.yml \
  up &

popd > /dev/null
