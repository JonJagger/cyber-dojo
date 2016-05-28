FROM java:8
MAINTAINER Frederic Merizen <frederic.merizen@soft-xki.com>

ENV LEIN_ROOT=1
COPY project.clj /tmp
RUN wget \
      -O /usr/bin/lein \
      --no-check-certificate \
      --no-cookies \
      https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein \
 && chmod 755 /usr/bin/lein \
 && cd /tmp \
 && lein deps \
 && rm project.clj \
 && mv ~/.lein ~/.m2 / \
 && ln -sf /.lein ~ \
 && ln -sf /.m2 ~ \
 && chown -R nobody /.lein /.m2
