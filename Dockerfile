FROM alpine:3.2
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# install
# o) tini (for pid 1 zombie reaping)
# o) docker-client
# o) ruby, ruby-bigdecimal, tzdata (for rails server)
# o) git (for cyber-dojo)
# o) bash (test scripts are written in bash)
#
# https://github.com/krallin/tini
# https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/
#
# Launching a docker app (that itself uses docker) is different on different OS's...
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
          git bash

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
# start looking at running as non root

USER root
# -D            no password
# -H            no home directory
# -u 19961      user-id=19961
# cyber-dojo    user-name=cyber-dojo
RUN adduser -D -H -u 19661 cyber-dojo
# there is no sudo command in Alpine
RUN apk --update add sudo
# cyber-dojo can [sudo docker ...] to
# TODO: restrict this to just having sudo on docker command (and socket?)
RUN echo "cyber-dojo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/cyber-dojo
# inside web container, running as cyber-dojo, this does not work
#     sudo docker images
# I think this is because cyber-dojo doesn't have rights to the socket on the *host*
# The host needs a cyber-dojo user too.
# I'm using Docker-Quickstart-Terminal
# $ docker-machine ssh default
# $ sudo adduser -D -H -u 19661 cyber-dojo
# $ sudo visudo
#   add following line to end of /etc/sudoers
#   cyber-dojoALL=NOPASSWD: ALL
# rebooted
# Ok. Now it works. But
# $ sudo cat /etc/sudoers
# doesn't have an entry for cyber-dojo. Is it hidden somewhere?
# Does rebooting default lose the cyber-dojo user? It seems so
# $ sudo deluser cyber-dojo
# deluser: unknown user cyber-dojo
# Hmmm. I also edited the sudo line above...
# Delete Docker-Toolbox and reinstall to get completely fresh default
# $ docker-machine ssh default
# $ id cyber-dojo
# confirms no cyber-dojo user on default
# Rebuilding web
# Ah toss. I lost all my docker images
# Now it helps they are smaller than they were.
# Rebuilding nginx,alpine,web
# Will need to rebuild gcc_assert too (from Alpine)
# That's finished. Yes. [sudo docker images] works. Excellent.
# Can progress past setup page displaying languages.
# caches gets languages cache and runner cache both owned
# by cyber-dojo. Creation of manifest after exercise is created fails.
# Yes. Because that needs permission under katas/ on the *host*
# lib/logs confirms it.
# Errno::EACCES (Permission denied @ dir_s_mkdir - /usr/src/cyber-dojo/app/katas/F2):
# lib/host_dir.rb:36:in `make'
#     FileUtils.mkdir_p(path)
# Trying same sudo trick. Replaced
#           FileUtils.mkdir_p(path)
#        with
#           shell.exec("sudo mkdir -p #{path}")
# worked.
# Now fails at
# Errno::EACCES (Permission denied @ rb_sysopen - /usr/src/cyber-dojo/app/katas/B8/0D65FA6C/manifest.json):
# lib/host_dir.rb:52:in `initialize'
#          File.open(pathed_filename, 'w') { |fd| fd.write(s) }
#
# How to do that with a sudo? Maybe something like...
#
#    https://gist.github.com/earlonrails/5505668
#
#    fd = IO.popen("sudo -u cyber-dojo 'cat > \"#{pathed_filename}\"'", "w+")
#    fd.write("sudo sh -c 'cat > #{s}'")
#    fd.close
#
# See also lib/host_disk_katas.rb line 85
#      _, exit_status = shell.cd_exec(path_of(kata), "mkdir #{valid_name} > /dev/null #{stderr_2_stdout}")
#
#
#
#
#
# Hmmm. Now I see clearly another dependency. If katas was a data-container I
# could resolve this easily. And it could be a data-container.
# It only doesn't need to be a data-container for James' style of use
# where files are re-used from katas folder and for security I need to
# stop the cyber-dojo.sh file from doing cd ../../../; rm -rf *
# Maybe have two yml files?
# tmp: Probe for katas folder, temporarily copy katas-data-container Dockerfile
# into katas, copy it, make sure its owned by cyber-dojo.
# katas: volume-mount katas folder - still needs to be writable by cyber-dojo user
#        as identified on the *host*.
#
# Duplication is suggesting a new shell.sudo_exec() function
# Also, multiple logs... suggests
#    cyber-dojo logs_rails
#    cyber-dojo logs_web
#    cyber-dojo logs_nginx
#



# - - - - - - - - - - - - - - - - - - - - - -
# copy cyber-dojo rails app

COPY . ${CYBER_DOJO_HOME}
RUN mkdir ${CYBER_DOJO_HOME}/app/caches
RUN chown -R cyber-dojo ${CYBER_DOJO_HOME}
WORKDIR ${CYBER_DOJO_HOME}

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]

EXPOSE 3000

USER cyber-dojo
