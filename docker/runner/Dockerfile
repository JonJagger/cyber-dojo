FROM cyberdojofoundation/user-base
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# install docker-client
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

ARG DOCKER_BINARY=/usr/bin/docker
USER root
RUN    apk --update add curl \
    && curl -O https://get.docker.com/builds/Linux/x86_64/docker-latest \
    && mv docker-latest ${DOCKER_BINARY} \
    && chmod +x ${DOCKER_BINARY} \
    && apk del curl
# THIS LINE FAILS with
# cannot mount volume over existing file, file exists \
# /mnt/sda1/var/lib/docker/aufs/mnt/fad73a91b449c1e763d470a4526a03a903b1642a451800d181e2b426d2dbc4a6/usr/bin/docker
VOLUME [ "${DOCKER_BINARY}" ]

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lib/runner sh files needs to run /usr/bin/docker
# after this sh file (running as cyber-dojo user) can do
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
VOLUME [ "${SUDO_FILE}" ]

CMD [ "data-container" ]
