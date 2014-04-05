# build-essential was built from 13.10 (saucy)

FROM       cyberdojo/language_ruby-1.9.3
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN gem install cucumber

# docker build -t  cyberdojo/language_ruby-1.9.3_cucumber  .
# docker push      cyberdojo/language_ruby-1.9.3_cucumber
# docker run -i -t cyberdojo/language_ruby-1.9.3_cucumber /bin/bash
