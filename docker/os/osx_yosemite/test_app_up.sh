#!/bin/bash

# Brings up cyber-dojo plus tests volume in OSX Docker Quickstart Terminal.
# Assumes yml files are in their respective git repo folders.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${DIR}

# remove existing containers
docker ps -aq | xargs docker rm -f

# remove existing images
../../rm_untagged_images.sh

# get test changes
cd ../../images/test
./build_docker_image.sh

# get code changes
cd ../../images/web
./osx_build_docker_image.sh

# bring up cyber-dojo + tests
cd ../../os/osx_yosemite
./app_up.sh

popd

# after this tests can be run *inside* the container, eg
# $ docker exec os_web_1 bash -c "cd /var/www/cyber-dojo/test/app_models && ./test_dojo.rb"