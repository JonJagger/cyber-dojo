#!/bin/bash

# Brings up cyber-dojo plus tests volume in OSX Docker Quickstart Terminal.
# Assumes yml files are in their respective git repo folders.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${DIR} > /dev/null

# remove existing containers
docker ps -aq | xargs docker rm -f

# remove existing images
../../rm_untagged_images.sh

# get test changes
cd ../..
cd images/test
./build_docker_image.sh

# get code changes
cd ../..
cd images/web
./osx_build_docker_image.sh

# get nginx changes
cd ../..
cd images/nginx
./build_docker_image.sh


# bring up cyber-dojo + tests
cd ../../os/osx_yosemite
./app_up.sh

popd > /dev/null

# after this tests can be run *inside* the container, eg
# $ docker exec os_web_1 bash -c "cd /var/www/cyber-dojo/test/app_models && ./test_dojo.rb"