FROM       cyberdojo/javascript-0.12.7
MAINTAINER Klaas Reineke <klaas.reineke@gmail.com>

RUN npm config set proxy http://192.168.100.129:3128
RUN npm config set https-proxy http://192.168.100.129:3128

RUN npm install -g qunit sinon chai 

RUN npm config set proxy ""
RUN npm config set https-proxy ""

