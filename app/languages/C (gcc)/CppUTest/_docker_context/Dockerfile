FROM       cyberdojofoundation/gcc-4.8.4
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN apt-get update && apt-get install -y \
  automake

RUN mkdir /cpputest
RUN cd /
RUN git clone https://github.com/cpputest/cpputest.git # comment to avoid cache
RUN cd cpputest && git checkout tags/v3.6
RUN cd cpputest && ./configure
RUN cd cpputest && make
RUN cd cpputest && make check
RUN chown -R www-data cpputest
RUN chgrp -R www-data cpputest
