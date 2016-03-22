#!/bin/bash

apt-get update
apt-get install -y libgtest-dev cmake

export CXX=clang++
export CC=clang

cd /usr/src/gtest
cmake .
make
mv libg* /usr/lib

# Remove cmake as it's no longer needed to make the image smaller
apt-get remove -y cmake
