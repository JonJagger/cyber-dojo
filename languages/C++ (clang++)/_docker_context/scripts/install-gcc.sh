#!/bin/bash

add-apt-repository ppa:ubuntu-toolchain-r/test

apt-get update
apt-get install --yes g++-5

update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 20
update-alternatives --config g++

update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 20
update-alternatives --config gcc
