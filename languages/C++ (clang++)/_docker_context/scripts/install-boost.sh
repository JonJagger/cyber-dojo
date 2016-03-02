#!/bin/bash

wget http://iweb.dl.sourceforge.net/project/boost/boost/1.60.0/boost_1_60_0.tar.bz2
tar --bzip2 -xf boost_1_60_0.tar.bz2

cd boost_1_60_0
./bootstrap.sh
./b2 install

cd ..
rm -rf boost_1_60_0
rm -f boost_1_60_0.tar.bz2
