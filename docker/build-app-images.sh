#!/bin/bash

pushd /var/www/cyber-dojo

folders=(exercises)
for folder in ${folders[*]}
do
  pushd ${folder}
  echo "---------------------------------------"
  echo "BUILDING: cyberdojofoundation/${folder}"
  echo "---------------------------------------"
  ./build-docker-image.sh
  popd
done

folders=(languages tmp rails web nginx)
for folder in ${folders[*]}
do
  pushd docker/${folder}_image
  echo "---------------------------------------"
  echo "BUILDING: cyberdojofoundation/${folder}"
  echo "---------------------------------------"
  ./build-docker-image.sh
  popd
done

popd
