FROM cyberdojofoundation/user-base
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 1. install tini (for pid 1 zombie reaping)
# https://github.com/krallin/tini
# https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/

USER root
RUN apk add --update --repository http://dl-1.alpinelinux.org/alpine/edge/community/ tini
ENTRYPOINT ["/usr/bin/tini", "--"]

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 2. install docker-client
# Launching a docker app (that itself uses docker) is
# different on different host OS's... eg
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
# I now install the docker client _inside_ the image.
# This means there is no host<-container uid dependency.
# But there is a host<-container docker version dependency.
#
# docker 1.11.0 now relies on four binaries
# See https://github.com/docker/docker/wiki/Engine-1.11.0
# See https://docs.docker.com/engine/installation/binaries/
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ARG  DOCKER_VERSION
USER root
RUN apk --update add curl \
  && curl -OL https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz \
  && tar -xvzf docker-${DOCKER_VERSION}.tgz \
  && mv docker/* /usr/bin/ \
  && apk del curl

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 3. lib/runner sh files needs to run /usr/bin/docker
# after this, the sh file (running as cyber-dojo user) can do
#     $ sudo -u docker-runner sudo docker run ...
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ARG  NEEDS_DOCKER_SUDO=cyber-dojo
ARG  GETS_DOCKER_SUDO=docker-runner
ARG  SUDO_FILE=/etc/sudoers.d/${GETS_DOCKER_SUDO}
USER root
# -D=no password, -H=no home directory
RUN  adduser -D -H ${GETS_DOCKER_SUDO}
# there is no sudo command in Alpine
RUN  apk --update add sudo
# cyber-dojo, on all hosts, can sudo -u docker-runner, without a password
RUN  echo "${NEEDS_DOCKER_SUDO} ALL=(${GETS_DOCKER_SUDO}) NOPASSWD: ALL" >  ${SUDO_FILE}
# docker-runner, on all hosts, without a password, can sudo /usr/bin/docker
RUN  echo "${GETS_DOCKER_SUDO}  ALL=NOPASSWD: ${DOCKER_BINARY} *"       >>  ${SUDO_FILE}

# - - - - - - - - - - - - - - - - - - - - - -
# 4. bundle install from cyber-dojo's Gemfile
# o) ruby, ruby-io-console ruby-bigdecimal, tzdata (for rails server)
# o) git (for cyber-dojo)
# o) bash (test scripts are written in bash)

USER root
RUN  apk --update add \
           ruby ruby-io-console ruby-bigdecimal tzdata \
           git \
           bash

ARG  CYBER_DOJO_HOME
USER root
RUN  mkdir -p ${CYBER_DOJO_HOME}
COPY Gemfile  ${CYBER_DOJO_HOME}
RUN  apk --update \
        add --virtual build-dependencies \
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
# 5. Copy the app source

USER root
RUN  mkdir -p ${CYBER_DOJO_HOME}
COPY . ${CYBER_DOJO_HOME}
RUN  chown -R cyber-dojo ${CYBER_DOJO_HOME}

# - - - - - - - - - - - - - - - - - - - - - -
WORKDIR ${CYBER_DOJO_HOME}
USER    cyber-dojo
EXPOSE  3000
