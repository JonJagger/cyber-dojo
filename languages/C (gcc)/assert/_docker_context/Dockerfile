FROM alpine:3.2
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN apk --update add gcc make musl-dev

RUN deluser xfs
RUN adduser -G www-data -D -H -u 33 www-data
