FROM       ubuntu:14.04
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# 14.04 (trusty)
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install git
RUN apt-get install automake
RUN apt-get install gnome-sharp2
RUN apt-get install mono-xsp4

RUN git clone https://github.com/mono/monodevelop.git

RUN cd monodevelop ; apt-get install -y libglade2.0-cil-dev
RUN cd monodevelop ; apt-get install -y monodoc-base
RUN cd monodevelop ; apt-get install -y monodevelop mono-vbnc
RUN cd monodevelop ; ./configure -Ðprofile=stable
RUN cd monodevelop ; make
RUN cd monodevelop ; make run

