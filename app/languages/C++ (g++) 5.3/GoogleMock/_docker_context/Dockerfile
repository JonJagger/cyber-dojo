FROM       cyberdojofoundation/gpp-5.3
MAINTAINER Michel Estermann <estermann.michel@gmail.com>

WORKDIR /usr/src

RUN apt-get update && apt-get install -y \
  wget \
  cmake \
  unzip

RUN wget http://googlemock.googlecode.com/files/gmock-1.7.0.zip
RUN unzip gmock-1.7.0.zip

RUN cd /usr/src/gmock-1.7.0 && cmake DCMAKE_CXX_FLAGS='-Wno-unused-local-typedefs' .
RUN cd /usr/src/gmock-1.7.0 && make
RUN cd /usr/src/gmock-1.7.0 && mv libg* /usr/lib && cp -rf include/gmock /usr/include
RUN cd /usr/src/gmock-1.7.0/gtest && mv libg* /usr/lib && cp -rf include/gtest /usr/include
