FROM       cyberdojo/gpp-4.8.1
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# build-essential was built from 13.10 (saucy)
RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y libgtest-dev
RUN apt-get install -y cmake
RUN cd /usr/src/gtest && cmake .
RUN cd /usr/src/gtest && make
RUN cd /usr/src/gtest && mv libg* /usr/lib
