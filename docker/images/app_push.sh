#!/bin/bash

names=(exercises languages katas tmp rails web nginx)
for name in ${names[*]}
do
  image=cyberdojofoundation/${name}
  echo "---------------------------------------"
  echo "PUSHING: ${image}"
  echo "---------------------------------------"
  docker push ${image}
done
