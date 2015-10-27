#!/bin/bash

sandbox_path=$1
container_name=$2
max_seconds=$3

cmd="timeout --signal=9 ${max_seconds}s ./cyber-dojo.sh 2>&1"

docker run \
  --rm \
  --user=www-data \
  --net=none \
  --volume=${sandbox_path}:/sandbox:rw \
  --workdir=/sandbox  \
  ${container_name} \
  /bin/bash -c "${cmd}"

