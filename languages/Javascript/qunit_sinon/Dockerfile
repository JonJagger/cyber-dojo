FROM       cyberdojofoundation/javascript-node
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN apt-get update
RUN apt-get upgrade -y

RUN npm install -global qunit chai sinon sinon-chai
ENV NODE_PATH /usr/lib/node_modules
