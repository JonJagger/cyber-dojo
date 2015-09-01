FROM       cyberdojofoundation/build-essential
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y libsqlite3-dev
RUN apt-get install -y sqlite3
RUN apt-get install -y bzip2 libbz2-dev

RUN apt-get install -y wget
RUN wget http://www.python.org/ftp/python/3.3.5/Python-3.3.5.tar.xz
RUN tar xJf ./Python-3.3.5.tar.xz
RUN cd ./Python-3.3.5 && ./configure --prefix=/opt/python3.3
RUN cd ./Python-3.3.5 && make
RUN cd ./Python-3.3.5 && make install
RUN ln -s /opt/python3.3/bin/python3.3 /bin/python
