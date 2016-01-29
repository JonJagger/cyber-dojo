#!/bin/bash

names=(exercises languages tmp rails web nginx)
for name in ${names[*]}
do
  image=cyberdojofoundation/${name}
  echo "---------------------------------------"
  echo "PULLING: ${image}"
  echo "---------------------------------------"
  docker pull ${image}
done
