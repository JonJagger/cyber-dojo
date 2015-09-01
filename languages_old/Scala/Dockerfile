FROM       cyberdojo/java-1.7
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y scala