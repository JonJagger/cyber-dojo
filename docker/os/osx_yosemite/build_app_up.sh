#!/bin/bash

# Brings up cyber-dojo plus tests volume in OSX Docker Quickstart Terminal.
# Assumes yml files are in their respective git repo folders.
#
# $1 = CYBER_DOJO_ROOT

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${DIR} > /dev/null

# remove existing containers
docker ps -aq | xargs docker rm -f

# remove untagged images
../../rm_untagged_images.sh

# remove existing images
#docker rmi -f cyberdojofoundation/rails  2&> /dev/null
docker rmi -f cyberdojofoundation/web 2&> /dev/null
docker rmi -f cyberdojofoundation/exercises  2&> /dev/null
docker rmi -f cyberdojofoundation/katas  2&> /dev/null
docker rmi -f cyberdojofoundation/languages  2&> /dev/null
docker rmi -f cyberdojofoundation/nginx  2&> /dev/null
docker rmi -f cyberdojofoundation/katas  2&> /dev/null
docker rmi -f cyberdojofoundation/test  2&> /dev/null
docker rmi -f cyberdojofoundation/tmp  2&> /dev/null

# - - - - - - - - - - - - - - - - - - - - - -
# rebuild images

export CYBER_DOJO_ROOT=${1}

# This takes quite a while. Only repeat if ${1} has changed
#cd ../..
#cd images/rails
#./build_docker_image.sh ${1}
#if [ $? -ne 0 ]; then
#  echo "BUILDING cyberdojofoundation/rails FAILED"
#  exit
#fi

cd ../..
cd images/web
./osx_build_docker_image.sh ${1}
if [ $? -ne 0 ]; then
  echo "BUILDING cyberdojofoundation/web FAILED"
  exit
fi

cd ../..
cd images/exercises
./build_docker_image.sh ${1}
if [ $? -ne 0 ]; then
  echo "BUILDING cyberdojofoundation/exercises FAILED"
  exit
fi

cd ../..
cd images/katas
./build_docker_image.sh ${1}
if [ $? -ne 0 ]; then
  echo "BUILDING cyberdojofoundation/katas FAILED"
  exit
fi

cd ../..
cd images/languages
./build_docker_image.sh ${1}
if [ $? -ne 0 ]; then
  echo "BUILDING cyberdojofoundation/languages FAILED"
  exit
fi

cd ../..
cd images/nginx
./build_docker_image.sh ${1}
if [ $? -ne 0 ]; then
  echo "BUILDING cyberdojofoundation/nginx FAILED"
  exit
fi

cd ../..
cd images/katas
./build_docker_image.sh ${1}
if [ $? -ne 0 ]; then
  echo "BUILDING cyberdojofoundation/katas FAILED"
  exit
fi

cd ../..
cd images/test
./build_docker_image.sh ${1}
if [ $? -ne 0 ]; then
  echo "BUILDING cyberdojofoundation/test FAILED"
  exit
fi

cd ../..
cd images/tmp
./build_docker_image.sh ${1}
if [ $? -ne 0 ]; then
  echo "BUILDING cyberdojofoundation/tmp FAILED"
  exit
fi

# - - - - - - - - - - - - - - - - - - - - - -
# bring up cyber-dojo + tests
cd ../../os/osx_yosemite
./app_up.sh ${1}

popd > /dev/null

# after this tests can be run *inside* the container, eg
# $ docker exec os_web_1 bash -c "cd /var/www/cyber-dojo/test/app_models && ./test_dojo.rb"