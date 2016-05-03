FROM       cyberdojofoundation/gpp-5.3
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN apt-get update && apt-get install -y \
  libgtest-dev \
  cmake

RUN cd /usr/src/gtest && cmake .
RUN cd /usr/src/gtest && make
RUN cd /usr/src/gtest && mv libg* /usr/lib
