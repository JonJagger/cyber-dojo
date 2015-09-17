FROM      debian:wheezy
MAINTAINER Klaas Reineke <klaas.reineke@gmail.com>

RUN apt-get update
RUN apt-get install --yes curl
RUN curl --silent --location https://deb.nodesource.com/setup_0.12 | bash -
RUN apt-get install --yes nodejs

RUN apt-get install -y npm
