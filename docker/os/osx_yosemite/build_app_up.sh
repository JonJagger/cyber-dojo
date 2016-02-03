#!/bin/bash

# Brings up cyber-dojo plus tests volume in OSX Docker Quickstart Terminal.
# Assumes yml files are in their respective git repo folders.
#
# $1 = CYBER_DOJO_ROOT

if [ -z "$1" ]; then
  echo "./build_app_up.sh  <CYBER_DOJO_ROOT>"
  exit
fi

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

IMAGES=(exercises katas languages nginx test tmp)
for image in ${IMAGES[*]}
do
  cd ../..
  cd images/${image}
  ./build_docker_image.sh ${1}
  if [ $? -ne 0 ]; then
    echo "BUILDING cyberdojofoundation/${image} FAILED"
    exit
  fi
done

# - - - - - - - - - - - - - - - - - - - - - -
# bring up cyber-dojo + tests
cd ../../os/osx_yosemite
./app_up.sh ${1}

popd > /dev/null

# after this tests can be run *inside* the container, eg
# $ docker exec os_web_1 bash -c "cd /var/www/cyber-dojo/test/app_models && ./test_dojo.rb"