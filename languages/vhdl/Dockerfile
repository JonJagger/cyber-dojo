FROM       cyberdojofoundation/build-essential
MAINTAINER Pablo Mansanet <pablo.mansanet@bluefruit.co.uk>

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:pgavin/ghdl
RUN apt-get update
RUN apt-get install ghdl -y
