FROM       cyberdojo/javascript-0.10.15
MAINTAINER Jon Jagger <jon@jaggersoft.com>
RUN npm install -g mocha
RUN cd /sandbox && printf "hello\n" | npm init -f && npm install --save-dev mocha chai sinon sinon-chai
