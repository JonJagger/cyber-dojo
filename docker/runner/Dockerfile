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

USER root
RUN    apk --update add curl \
    && curl -O https://get.docker.com/builds/Linux/x86_64/docker-latest \
    && mv docker-latest /usr/bin/docker \
    && chmod +x /usr/bin/docker \
    && apk del curl
VOLUME [ "/usr/bin/docker" ]

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# runner needs sudo to be able to run /usr/bin/docker
# there is no sudo command in Alpine
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
USER root
RUN apk --update add sudo
RUN echo "cyber-dojo ALL=(ALL) NOPASSWD: /usr/bin/docker" > /etc/sudoers.d/cyber-dojo
VOLUME [ "/etc/sudoers.d/cyber-dojo" ]

CMD [ "data-container" ]
