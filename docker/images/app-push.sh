#!/bin/bash

names=(exercises languages nginx rails tmp web)
for name in ${names[*]}
do
  image=cyberdojofoundation/${name}
  echo "---------------------------------------"
  echo "PUSHING: ${image}"
  echo "---------------------------------------"
  docker push ${image}
done
