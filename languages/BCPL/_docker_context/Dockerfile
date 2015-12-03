FROM       cyberdojofoundation/build-essential
MAINTAINER Jon Jagger <jon@jaggersoft.com>


RUN apt-get update && apt-get install --yes wget

RUN mkdir distribution
WORKDIR distribution
RUN wget http://www.cl.cam.ac.uk/users/mr/BCPL/bcpl.tgz
RUN tar xvf bcpl.tgz
WORKDIR BCPL/cintcode
RUN . os/linux/setbcplenv
RUN make clean
RUN make -f MakefileRaspi sys

ENV HOME=/

