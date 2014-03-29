# build-essential was built from 13.10 (saucy)

FROM       cyberdojo/build-essential
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y ruby

ADD https://raw.githubusercontent.com/JonJagger/cyberdojo/master/languages/Ruby/cyber-dojo.sh    /var/www/cyberdojo/katas/00/00000000/
ADD https://raw.githubusercontent.com/JonJagger/cyberdojo/master/languages/Ruby/manifest.json    /var/www/cyberdojo/katas/00/00000000/
ADD https://raw.githubusercontent.com/JonJagger/cyberdojo/master/languages/Ruby/test_untitled.rb /var/www/cyberdojo/katas/00/00000000/
ADD https://raw.githubusercontent.com/JonJagger/cyberdojo/master/languages/Ruby/untitled.rb      /var/www/cyberdojo/katas/00/00000000/

RUN chmod +r /var/www/cyberdojo/katas/00/00000000/*
RUN chmod +x /var/www/cyberdojo/katas/00/00000000/cyber-dojo.sh

# docker build -t  cyberdojo/language_ruby-1.9.3  .
# docker push      cyberdojo/language_ruby-1.9.3
# docker run -i -t cyberdojo/language_ruby-1.9.3 /bin/bash
