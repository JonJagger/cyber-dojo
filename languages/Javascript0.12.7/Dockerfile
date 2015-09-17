FROM      cyberdojofoundation/build-essential
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN apt-get update
RUN apt-get install --yes curl
RUN curl --silent --location https://deb.nodesource.com/setup_0.12 | bash -
RUN apt-get install --yes nodejs

RUN apt-get install --yes build-essential
