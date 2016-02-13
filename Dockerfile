FROM alpine:3.2
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# install
# o) tini (for pid 1 zombie reaping)
# o) docker-client (see docker/docker-from-docker-readme.txt)
# o) ruby, ruby-bigdecimal, tzdata (for rails server)
# o) git (for cyber-dojo)
#
# https://github.com/krallin/tini
# https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/
#
# Launching a docker app (that itself uses docker) is different on different OS's...
#
# OSX Yosemite
# ------------
# The Docker-Quickstart-Terminal uses docker-machine to forward
# docker commands to a boot2docker VM called default.
# In this VM the docker binary lives at /usr/local/bin/
#
#    -v /var/run/docker.dock:/var/run/docker.sock
#    -v /usr/local/bin/docker:/usr/local/bin/docker
#
# Ubuntu Trusty
# -------------
# The docker binary lives at /usr/bin and has a dependency on apparmor 1.1
#
#    -v /var/run/docker.dock:/var/run/docker.sock
#    -v /usr/bin/docker:/usr/bin/docker
#    -v /usr/lib/x86_64-linux-gnu/libapparmor.so.1.1.0 ...
#
# Debian Jessie
# -------------
# The docker binary lives at /usr/bin and has a dependency to apparmor 1.2
#
#    -v /var/run/docker.dock:/var/run/docker.sock
#    -v /usr/bin/docker:/usr/bin/docker
#    -v /usr/lib/x86_64-linux-gnu/libapparmor.so.1.2.0 ...
#
# I originally used docker-compose extension files specific to each OS.
# I now install the docker client inside the docker.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

RUN    apk add --update --repository http://dl-1.alpinelinux.org/alpine/edge/community/ tini \
    && apk --update add curl \
    && curl -O https://get.docker.com/builds/Linux/x86_64/docker-latest \
    && mv docker-latest /usr/bin/docker \
    && chmod +x /usr/bin/docker \
    && apk del curl \
    && apk --update add \
          ruby ruby-bigdecimal tzdata \
          git

# - - - - - - - - - - - - - - - - - - - - - -
# bundle install from cyber-dojo's Gemfile

ARG CYBER_DOJO_HOME

RUN  mkdir -p     ${CYBER_DOJO_HOME}
COPY Gemfile      ${CYBER_DOJO_HOME}
RUN apk --update add --virtual build-dependencies \
      build-base \
      ruby-dev \
      openssl-dev \
      postgresql-dev \
      libc-dev \
      linux-headers \
    && gem install bundler --no-ri --no-rdoc \
    && cd ${CYBER_DOJO_HOME} ; bundle install --without development test \
    && apk del build-dependencies

# - - - - - - - - - - - - - - - - - - - - - -
# copy cyber-dojo rails app

COPY . ${CYBER_DOJO_HOME}
RUN mkdir \
    ${CYBER_DOJO_HOME}/caches \
    ${CYBER_DOJO_HOME}/log \
    ${CYBER_DOJO_HOME}/tmp

WORKDIR ${CYBER_DOJO_HOME}

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]

EXPOSE 3000
