#!/bin/bash

wget https://github.com/Microsoft/GSL/archive/master.zip

unzip master.zip
cp -r GSL-master/include /usr/local

rm -rf GSL-master
rm -f master.zip
