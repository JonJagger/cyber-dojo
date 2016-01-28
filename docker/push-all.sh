#!/bin/bash

names=(languages exercises tmp rails web nginx)
for name in ${names[*]}
do
  docker push cyberdojofoundation/${name}
done
