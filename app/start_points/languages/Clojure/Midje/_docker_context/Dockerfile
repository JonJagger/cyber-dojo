FROM cyberdojofoundation/clojure-1.8.0
MAINTAINER Frederic Merizen <frederic.merizen@soft-xki.com>

ENV MIDJE_COLORIZE=false
COPY project.clj /tmp
RUN cd /tmp \
 && lein deps \
 && lein midje --help \
 && chown -R nobody /.m2 \
 && rm project.clj
