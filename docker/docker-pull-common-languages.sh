#!/bin/bash

HUB=cyberdojofoundation

IMAGES=(gcc_assert)
#TODO: add more alpine images

for IMAGE in ${IMAGES[*]}
do
  docker pull ${HUB}/${IMAGE}
done
