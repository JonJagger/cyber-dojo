FROM      cyberdojofoundation/build-essential
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ENV http_proxy "http://192.168.100.129:3128/"
ENV https_proxy "http://192.168.100.129:3128/"

RUN apt-get update
RUN apt-get install --yes curl
RUN curl --silent --location https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get install --yes nodejs

RUN npm install --global n

RUN n 0.12.7
RUN n 4.1.1

RUN chmod -R a+w /usr/local

RUN apt-get install --yes build-essential
