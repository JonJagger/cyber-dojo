FROM       cyberdojo/java-1.8
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# build-essential was built from 13.10 (saucy)
RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN wget http://dist.groovy.codehaus.org/distributions/groovy-binary-2.2.0.zip
RUN unzip groovy-binary-2.2.0.zip

