FROM       ubuntu:14.04
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# 14.04 (trusty)
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y gcc
RUN apt-get install -y libc-dev
RUN apt-get install -y curl
RUN curl -sf -L https://static.rust-lang.org/rustup.sh | sudo sh

