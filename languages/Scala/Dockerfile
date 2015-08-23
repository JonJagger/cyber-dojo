FROM       cyberdojofoundation/java-1.8
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y wget

WORKDIR /
RUN wget http://downloads.typesafe.com/scala/2.11.7/scala-2.11.7.tgz
RUN tar -xf scala-2.11.7.tgz

ENV SCALA_HOME=/scala-2.11.7
ENV PATH=$PATH:$SCALA_HOME/bin
