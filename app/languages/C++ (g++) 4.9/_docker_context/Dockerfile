FROM       cyberdojofoundation/build-essential
MAINTAINER Michel Estermann <estermann.michel@gmail.com>

RUN apt-get update && apt-get install --yes software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test

RUN apt-get update && apt-get install --yes g++-4.9
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 20
RUN update-alternatives --config g++

