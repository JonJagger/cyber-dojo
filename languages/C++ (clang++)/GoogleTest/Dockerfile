FROM       cyberdojofoundation/clangpp-3.6.0
MAINTAINER Byran Wills-Heath <byran@adgico.co.uk>

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y libgtest-dev
RUN apt-get install -y cmake
WORKDIR /usr/src/gtest
RUN cmake .
RUN make
RUN mv libg* /usr/lib

