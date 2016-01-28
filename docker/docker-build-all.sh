#!/bin/bash

folders=(languages exercises docker/tmp_image docker/rails_image docker/web_image docker/nginx_image)
for folder in ${folders[*]}
do
  pushd ${folder}
  ./build-docker-image.sh
  popd
done
