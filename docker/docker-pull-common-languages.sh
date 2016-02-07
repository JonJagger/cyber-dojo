#!/bin/sh

HUB=cyberdojofoundation

IMAGES=(gcc_assert)

for IMAGE in ${IMAGES[*]}
do
  docker pull ${HUB}/${IMAGE}
done
