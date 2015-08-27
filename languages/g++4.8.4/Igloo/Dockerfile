FROM       cyberdojofoundation/gpp-4.8.4
MAINTAINER Byran Wills-Heath <byran@adgico.co.uk>

RUN apt-get update
RUN apt-get upgrade -y

WORKDIR /usr/src
RUN git clone https://github.com/joakimkarlsson/igloo.git
WORKDIR /usr/src/igloo
RUN git checkout -b cyberdojorelease igloo.1.1.1
RUN git submodule init
RUN git submodule update
RUN mkdir /usr/include/igloo
RUN cp -rfv /usr/src/igloo/igloo/ /usr/include
