#!/bin/bash

# Brings up cyber-dojo plus tests volume in OSX Docker Quickstart Terminal.
# Assumes yml files are in their respective git repo folders.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${DIR}

# remove existing containers
docker rm -f $(docker ps -aq)

# remove existing images
../../rm_untagged_images.sh

# get test changes
cd ../../images/test
./build_docker_image.sh

# get code changes
cd ../../images/web
./build_docker_image.sh

# bring up cyber-dojo + tests
cd ../../os/osx_yosemite
docker-compose -f ../docker-compose.yml -f docker-compose.osx.yml -f docker-compose.osx-test.yml up &

popd
