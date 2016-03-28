#!/bin/bash

wget http://llvm.org/releases/3.8.0/clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz
tar -xvf clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz
cp -r clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-14.04/* /usr/

# Make clang the default compiler
update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100

# Clean up to make the image smaller
rm -rf clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-14.04
rm -f clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz
