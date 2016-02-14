FROM       cyberdojofoundation/fortran-4.8.4
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN apt-get update && apt-get install -y \
  ruby \
  make

RUN gem install funit

ENV FC gfortran
