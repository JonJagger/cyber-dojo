# https://github.com/phusion/passenger-docker
FROM phusion/passenger-ruby22
# I tried FROM Alpine. Super small but each call to lib/docker_tmp_runner.rb
# left behind zombie/orphan processes.
# See comments in lib/host_shell.rb
# https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/

MAINTAINER Jon Jagger <jon@jaggersoft.com>

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# install docker-client (see docker/docker-from-docker-readme.txt)

RUN curl -O https://get.docker.com/builds/Linux/x86_64/docker-latest \
    && mv docker-latest /usr/bin/docker \
    && chmod +x /usr/bin/docker

RUN gem update --system
RUN gem install rails --version 4.0.3

ARG CYBER_DOJO_HOME

# - - - - - - - - - - - - - - - - - - - - - -
# bundle install from cyber-dojo's Gemfile

RUN  mkdir -p     ${CYBER_DOJO_HOME}
COPY Gemfile      ${CYBER_DOJO_HOME}
RUN gem install bundler --no-ri --no-rdoc \
    && cd ${CYBER_DOJO_HOME} ; bundle install --without development test

# - - - - - - - - - - - - - - - - - - - - - -
# copy cyber-dojo rails app

COPY . ${CYBER_DOJO_HOME}
RUN mkdir \
    ${CYBER_DOJO_HOME}/caches \
    ${CYBER_DOJO_HOME}/log \
    ${CYBER_DOJO_HOME}/tmp

WORKDIR ${CYBER_DOJO_HOME}

EXPOSE 3000

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
