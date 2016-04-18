FROM cyberdojofoundation/clangpp-3.8.0
RUN apt-get update && apt-get -y install wget cmake unzip
RUN wget https://github.com/cgreen-devs/cgreen/archive/master.zip
RUN unzip master.zip
RUN cd cgreen-master && mkdir build && cd build && cmake -DCGREEN_WITH_CXX:bool=ON .. && make && make install
