FROM       cyberdojo/gpp-4.8.1
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# build-essential was built from 13.10 (saucy)
RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y automake

RUN mkdir /cpputest
RUN cd /
RUN git clone https://github.com/cpputest/cpputest.git # comment to avoid cache
RUN cd cpputest && git checkout tags/v3.6
RUN cd cpputest && ./configure
RUN cd cpputest && make
RUN cd cpputest && make check
RUN chown -R www-data cpputest
RUN chgrp -R www-data cpputest
