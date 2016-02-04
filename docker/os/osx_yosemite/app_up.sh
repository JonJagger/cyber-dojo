#!/bin/bash

# Brings up cyber-dojo in OSX Docker Quickstart Terminal.
# Assumes yml files are in their respective git repo folders.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${DIR} > /dev/null

# create and start containers
CYBER_DOJO_ROOT=${1:-/var/www/cyber-dojo}
export CYBER_DOJO_ROOT=${CYBER_DOJO_ROOT}
CYBER_DOJO_MODE=${2:-production}
export CYBER_DOJO_MODE=${CYBER_DOJO_MODE}

docker-compose \
  --file ../docker-compose.yml \
  --file docker-compose.osx.yml \
  up &

popd > /dev/null
