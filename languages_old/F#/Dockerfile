FROM       ubuntu:14.04
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# 14.04 (trusty)
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y mono-complete
RUN apt-get install -y fsharp

RUN mozroots --import --sync
RUN apt-get install -y curl
RUN curl -L http://nuget.org/nuget.exe -o nuget.exe

RUN usermod -m -d /home/www-data www-data
RUN mkdir /home/www-data
RUN chgrp www-data /home/www-data
RUN chown www-data /home/www-data
ENV HOME /home/www-data

RUN mkdir /etc/mono/registry
RUN chmod uog+rw /etc/mono/registry