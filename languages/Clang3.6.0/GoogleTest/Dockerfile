FROM       adgico/clang-3.6.0
MAINTAINER Byran Wills-Heath <byran@adgico.co.uk>

RUN apt-get install -y libgtest-dev
RUN apt-get install -y cmake
RUN cd /usr/src/gtest && cmake .
RUN cd /usr/src/gtest && make
RUN cd /usr/src/gtest && mv libg* /usr/lib

