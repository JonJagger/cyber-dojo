FROM       ubuntu:14.04
MAINTAINER Michel Estermann <estermann.michel@gmail.com>
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y g++-4.9
RUN apt-get install -y build-essential
RUN apt-get install -y automake
RUN apt-get install -y git
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 20 
RUN update-alternatives --config g++

