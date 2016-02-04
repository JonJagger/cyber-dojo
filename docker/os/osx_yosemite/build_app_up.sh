#!/bin/bash

# Brings up cyber-dojo in OSX Docker Quickstart Terminal.
# Assumes yml files are in their respective git repo folders.
#
# $1 = CYBER_DOJO_ROOT

if [ -z "$1" ]; then
  echo "./build_app_up.sh CYBER_DOJO_ROOT"
  exit
fi
export CYBER_DOJO_ROOT=${1}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${DIR} > /dev/null

# remove existing containers
docker ps -aq | xargs docker rm -f

# remove untagged images
../../rm_untagged_images.sh

# remove existing images
IMAGES=(tmp web nginx)
for image in ${IMAGES[*]}
do
  #docker rmi -f cyberdojofoundation/${image} 2&> /dev/null
  true
done

# - - - - - - - - - - - - - - - - - - - - - -
# rebuild images

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
# $ docker exec os_web_1 bash -c "cd test/app_models && ./test_dojo.rb"