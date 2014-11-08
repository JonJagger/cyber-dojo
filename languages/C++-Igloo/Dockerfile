FROM       cyberdojo/gpp-4.8.1
MAINTAINER Byran Wills-Heath <byran@adgico.co.uk>

# build-essential was built from 13.10 (saucy)
RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN cd /usr/src && git clone https://github.com/joakimkarlsson/igloo.git
RUN cd /usr/src/igloo && git checkout -b cyberdojorelease igloo.1.1.1
RUN cd /usr/src/igloo && git submodule init
RUN cd /usr/src/igloo && git submodule update
RUN mkdir /usr/include/igloo
RUN cp -rfv /usr/src/igloo/igloo/ /usr/include
