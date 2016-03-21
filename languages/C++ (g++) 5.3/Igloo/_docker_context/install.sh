#!/bin/bash

cd /usr/src
git clone https://github.com/joakimkarlsson/igloo.git
cd igloo
git checkout -b cyberdojorelease igloo.1.1.1
git submodule init
git submodule update

mkdir -p /usr/include/igloo
cp -rfv /usr/src/igloo/igloo/ /usr/include

cd ..
rm -rf igloo
