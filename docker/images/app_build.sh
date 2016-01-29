#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${DIR}

folders=(exercises languages tmp rails web nginx)
for folder in ${folders[*]}
do
  pushd ${folder}
  echo "---------------------------------------"
  echo "BUILDING: cyberdojofoundation/${folder}"
  echo "---------------------------------------"
  ./build-docker-image.sh
  popd
done

popd
