FROM cyberdojofoundation/alpine_base
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN apk --update add gcc make musl-dev

# See comment in timeout script itself
COPY timeout /usr/local/bin
RUN chmod +x /usr/local/bin/timeout
