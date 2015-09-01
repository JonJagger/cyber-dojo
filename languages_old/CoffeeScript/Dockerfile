FROM       cyberdojo/javascript_node-0.10.15
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# build-essential was built from 13.10 (saucy)
RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN npm install -g coffee-script