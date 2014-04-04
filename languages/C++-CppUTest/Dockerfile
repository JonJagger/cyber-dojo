FROM       cyberdojo/language_gpp-4.8.1
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# build-essential was built from 13.10 (saucy)
RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN mkdir /cpputest
RUN cd /
RUN git clone https://github.com/cpputest/cpputest.git
RUN cd cpputest && git checkout tags/v3.5
RUN cd cpputest && ./configure
RUN cd cpputest && make
RUN cd cpputest && make check
RUN chown -R www-data cpputest
RUN chgrp -R www-data cpputest

# docker build -t  cyberdojo/language_gpp-4.8.1_cpputest .
# docker push      cyberdojo/language_gpp-4.8.1_cpputest
# docker run -i -t cyberdojo/language_gpp-4.8.1_cpputest /bin/bash
