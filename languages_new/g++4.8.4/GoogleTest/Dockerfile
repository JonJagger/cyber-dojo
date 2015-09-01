FROM       cyberdojofoundation/gpp-4.8.4
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y libgtest-dev
RUN apt-get install -y cmake
RUN cd /usr/src/gtest && cmake .
RUN cd /usr/src/gtest && make
RUN cd /usr/src/gtest && mv libg* /usr/lib
