FROM       cyberdojo/gpp-4.8.1
MAINTAINER Michel Estermann <estermann.michel@gmail.com>

# build-essential was built from 13.10 (saucy)
RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

WORKDIR /usr/src
RUN apt-get install wget
RUN wget http://googlemock.googlecode.com/files/gmock-1.7.0.zip
RUN apt-get install -y cmake unzip
RUN unzip gmock-1.7.0.zip
RUN cd /usr/src/gmock-1.7.0 && cmake DCMAKE_CXX_FLAGS='-Wno-unused-local-typedefs' .
RUN cd /usr/src/gmock-1.7.0 && make
RUN cd /usr/src/gmock-1.7.0 && mv libg* /usr/lib && cp -rf include/gmock /usr/include
RUN cd /usr/src/gmock-1.7.0/gtest && mv libg* /usr/lib && cp -rf include/gtest /usr/include
