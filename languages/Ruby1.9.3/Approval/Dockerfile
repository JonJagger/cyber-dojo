FROM       cyberdojofoundation/ruby-1.9.3_rspec
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install zlib1g-dev
RUN gem install --no-rdoc --no-ri approvals
