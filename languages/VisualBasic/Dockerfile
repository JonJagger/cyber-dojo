FROM       ubuntu:14.04
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# 14.04 (trusty)
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y git
RUN apt-get install -y automake
RUN apt-get install -y gnome-sharp2
RUN apt-get install -y mono-xsp4

RUN git clone https://github.com/mono/monodevelop.git

RUN cd monodevelop ; apt-get install -y libglade2.0-cil-dev
RUN cd monodevelop ; apt-get install -y monodoc-base
RUN cd monodevelop ; apt-get install -y monodevelop mono-vbnc

#RUN cd monodevelop ; apt-get install -y gettext
#RUN cd monodevelop ; ./configure --profile=stable
#RUN cd monodevelop ; apt-get install -y make
#RUN cd monodevelop ; make
#RUN cd monodevelop ; make run

