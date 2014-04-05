# build-essential was built from 13.10 (saucy)

FROM       cyberdojo/build-essential
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y ruby

# docker build -t  cyberdojo/language_ruby-1.9.3_test_unit  .
# docker push      cyberdojo/language_ruby-1.9.3_test_unit
# docker run -i -t cyberdojo/language_ruby-1.9.3_test_unit /bin/bash
