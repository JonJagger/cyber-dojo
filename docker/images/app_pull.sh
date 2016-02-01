#!/bin/bash

names=(exercises languages katas tmp rails web test nginx)
for name in ${names[*]}
do
  image=cyberdojofoundation/${name}
  echo "---------------------------------------"
  echo "PULLING: ${image}"
  echo "---------------------------------------"
  docker pull ${image}
done
