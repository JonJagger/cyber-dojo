#!/bin/bash

names=(exercises languages nginx rails tmp web)
for name in ${names[*]}
do
  image=cyberdojofoundation/${name}
  echo "---------------------------------------"
  echo "PULLING: ${image}"
  echo "---------------------------------------"
  docker pull ${image}
done
