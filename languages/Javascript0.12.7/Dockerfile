FROM      cyberdojofoundation/build-essential
MAINTAINER Jon Jagger <jon@jaggersoft.com>

ENV http_proxy  http://192.168.100.129:3128
ENV https_proxy  http://192.168.100.129:3128

RUN apt-get update
RUN apt-get install --yes curl
RUN curl --silent --location https://deb.nodesource.com/setup_0.12 | bash -
RUN apt-get install --yes nodejs

RUN apt-get install --yes build-essential

ENV http_proxy "" 
ENV https_proxy ""
