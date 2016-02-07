#!/bin/sh

IMAGES=(gcc_assert)
HUB=cyberdojofoundation

for IMAGE in ${IMAGES[*]}
do
  docker pull ${HUB}/${IMAGE}
done
