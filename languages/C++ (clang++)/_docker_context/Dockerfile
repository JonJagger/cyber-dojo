FROM       cyberdojofoundation/build-essential
MAINTAINER Byran Wills-Heath <byran@adgico.co.uk>

ENV CXX=clang++ CC=clang

ADD scripts/* .
RUN ./install-clang.sh
