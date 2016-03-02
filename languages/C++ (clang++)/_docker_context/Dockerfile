FROM       cyberdojofoundation/build-essential
MAINTAINER Byran Wills-Heath <byran@adgico.co.uk>

ENV CXX=clang++ CC=clang

ADD scripts/* ./

RUN ./install-tools.sh && \
    ./install-gcc.sh && \
    ./install-clang.sh && \
    ./install-boost.sh && \
    ./install-gsl.sh   && \
    ./remove-tools.sh  && \
    rm /*.sh
