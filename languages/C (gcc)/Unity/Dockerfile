FROM       cyberdojofoundation/gcc-4.8.4
MAINTAINER Byran Wills-Heath <byran@adgico.co.uk>

# Ruby is needed for the script that builds the main function

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y ruby

# Install utilities to download the unit test framework

RUN apt-get install -y wget
RUN apt-get install -y unzip

# Download and extract Unity, there is no version labelling on the ThrowTheSwitch/Unity GitHub
# repository so download from my fork that has version tags espically for cyberdojo

WORKDIR /

RUN wget https://github.com/byran/Unity/archive/CyberDojo_Release_1.zip
RUN unzip CyberDojo_Release_1.zip
RUN mv Unity-CyberDojo_Release_1 unity
