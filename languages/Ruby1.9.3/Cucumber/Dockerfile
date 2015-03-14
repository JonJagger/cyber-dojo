FROM       cyberdojo/ruby-1.9.3_rspec
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN gem install --no-rdoc --no-ri shoulda
RUN gem install --no-rdoc --no-ri cucumber
