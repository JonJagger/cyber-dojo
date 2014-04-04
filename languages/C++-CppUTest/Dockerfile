FROM       cyberdojo/language_gpp-4.8.1
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# build-essential was built from 13.10 (saucy)
RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y cpputest


# docker build -t  cyberdojo/language_gpp-1.8_cpputest .
# docker push      cyberdojo/language_gpp-1.8_cpputest
# docker run -i -t cyberdojo/language_gpp-1.8_cpputest /bin/bash