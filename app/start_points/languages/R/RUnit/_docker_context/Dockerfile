FROM       cyberdojofoundation/r-3.0.1
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN apt-get update && apt-get install --yes \
  wget

COPY install_RUnit.R /
RUN cd / && Rscript install_RUnit.R
