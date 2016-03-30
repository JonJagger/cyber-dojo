#!/bin/bash

apt-get update
apt-get install -y automake

mkdir /cpputest
cd /
git clone https://github.com/cpputest/cpputest.git
cd cpputest
git checkout tags/v3.6
./configure
make
make check
cd /
chown -R www-data cpputest
chgrp -R www-data cpputest
