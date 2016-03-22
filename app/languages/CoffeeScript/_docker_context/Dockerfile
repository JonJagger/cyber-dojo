FROM       cyberdojofoundation/build-essential
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN apt-get update && apt-get install --yes \
  curl

RUN curl --silent --location https://deb.nodesource.com/setup_4.x | bash -

RUN apt-get update && apt-get install --yes \
  nodejs

RUN npm install --global jshint

RUN npm install --global n
RUN n 0.12.7
RUN n 4.1.1 # keep old version for backward compatibility with old Katas
RUN n 4.2.1

RUN chmod -R a+w /usr/local

RUN apt-get update && apt-get install --yes \
  build-essential

RUN npm install -g coffee-script
