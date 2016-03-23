#!/bin/bash

apt-get update
apt-get install -y wget unzip software-properties-common

# Install gcc 5.3
add-apt-repository ppa:ubuntu-toolchain-r/test

apt-get update
apt-get install --yes g++-5 libbz2-dev libz-dev

update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 20
update-alternatives --config g++

update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 20
update-alternatives --config gcc

# Install boost
wget http://iweb.dl.sourceforge.net/project/boost/boost/1.60.0/boost_1_60_0.tar.bz2
tar --bzip2 -xf boost_1_60_0.tar.bz2

cd boost_1_60_0
./bootstrap.sh
./b2 install

cd ..
rm -rf boost_1_60_0
rm -f boost_1_60_0.tar.bz2

# Install GSL
wget https://github.com/Microsoft/GSL/archive/master.zip

unzip master.zip
cp -r GSL-master/include /usr/local

rm -rf GSL-master
rm -f master.zip

# Install Fake Function Framework
cd /usr/local/include
wget https://raw.githubusercontent.com/meekrosoft/fff/master/fff.h

# Update the Dynamic Linker Run Time Bindings
ldconfig
