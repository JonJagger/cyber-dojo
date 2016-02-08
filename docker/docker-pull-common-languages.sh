#!/bin/bash

# Pulls a selection of common language+test images
# from the cyberdojofoundation hub.
# These pulled images can then be chosen from when
# creating a cyber-dojo practice session.

HUB=cyberdojofoundation

IMAGES=(gcc_assert)
#TODO: add more alpine images

for IMAGE in ${IMAGES[*]}
do
  docker pull ${HUB}/${IMAGE}
done
