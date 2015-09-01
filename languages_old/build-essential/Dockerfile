FROM       ubuntu:13.10
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# build-essential was built from 13.10 (saucy)
RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y build-essential
RUN apt-get install -y automake
RUN apt-get install -y git

