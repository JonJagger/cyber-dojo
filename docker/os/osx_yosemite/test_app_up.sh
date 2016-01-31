#!/bin/bash

# Brings up cyber-dojo +tests volume in OSX Docker Quickstart Terminal.
# Assumes yml files are in their respective git repo folders.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${DIR}

cd ../..
cd images/test
./build_docker_image.sh

cd ../..
cd images/web
./build_docker_image.sh

cd ../..
cd os/osx_yosemite

docker rm -f $(docker ps -aq)

docker-compose -f docker-compose.osx-test.yml up &

popd
