FROM       cyberdojofoundation/javascript-node
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN apt-get update
RUN apt-get upgrade -y

RUN npm install -global mocha chai sinon sinon-chai
ENV NODE_PATH /usr/local/lib/node_modules
