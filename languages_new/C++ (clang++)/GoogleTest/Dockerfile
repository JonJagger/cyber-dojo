FROM       cyberdojofoundation/clang-3.6.0
MAINTAINER Byran Wills-Heath <byran@adgico.co.uk>

RUN apt-get install -y libgtest-dev
RUN apt-get install -y cmake
WORKDIR /usr/src/gtest
RUN cmake .
RUN make
RUN mv libg* /usr/lib

