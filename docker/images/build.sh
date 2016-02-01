#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${DIR}

folders=(exercises languages katas tmp rails web test nginx)
for folder in ${folders[*]}
do
  pushd ${folder}
  echo "---------------------------------------"
  echo "BUILDING: cyberdojofoundation/${folder}"
  echo "---------------------------------------"
  ./build_docker_image.sh
  popd
done

popd
