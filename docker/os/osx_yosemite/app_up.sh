#!/bin/bash

# Brings up cyber-dojo in OSX Docker Quickstart Terminal.
# Assumes yml files are in their respective git repo folders.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${DIR} > /dev/null

# create and start containers
docker-compose \
  --file ../docker-compose.yml \
  --file docker-compose.osx.yml up &

popd > /dev/null
