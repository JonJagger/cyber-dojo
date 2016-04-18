FROM cyberdojofoundation/gcc-4.8.4
RUN apt-get update && apt-get -y install wget cmake unzip
RUN wget https://github.com/cgreen-devs/cgreen/archive/master.zip
RUN unzip master.zip
RUN cd cgreen-master && mkdir build && cd build && cmake .. && make && make install
