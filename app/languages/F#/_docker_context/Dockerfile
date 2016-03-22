FROM       cyberdojofoundation/build-essential
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN apt-get update && apt-get install --yes \
  mono-complete \
  fsharp

RUN mozroots --import --sync
RUN apt-get update && apt-get install --yes curl
RUN curl -L http://nuget.org/nuget.exe -o nuget.exe

RUN usermod -m -d /home/www-data www-data
RUN mkdir /home/www-data
RUN chgrp www-data /home/www-data
RUN chown www-data /home/www-data
ENV HOME /home/www-data

RUN mkdir /etc/mono/registry
RUN chmod uog+rw /etc/mono/registry
