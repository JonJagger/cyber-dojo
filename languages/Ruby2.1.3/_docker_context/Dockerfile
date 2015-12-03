FROM       cyberdojofoundation/build-essential
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN apt-get update && apt-get install --yes wget
RUN wget --no-check-certificate https://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.3.tar.gz
RUN tar xzvf ruby-2.1.3.tar.gz
RUN cd ruby-2.1.3 && ./configure --disable-install-doc
RUN cd ruby-2.1.3 && make
RUN cd ruby-2.1.3 && make install
RUN ln -s /usr/local/bin/ruby /usr/bin/ruby
