FROM alpine:3.2
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# lib/docker_tmp_runner.sh does this...
# docker exec ... ${CID} sh -c "... && usermod --home ${SANDBOX} nobody"
#
# The usermod is for old-style Ubuntu language-images that rely on HOME, such as C#-NUnut.
# The Alpine shadow package provides usermod.
# Fortunately with the same syntax as on Ubuntu.
# I don't yet have any Alpine based language-images that require the
# usermod but its entirely likely I will do.

USER root
RUN  apk --update add sudo
RUN  apk add --update --repository http://dl-1.alpinelinux.org/alpine/edge/testing/ shadow

# But this doesn't work...
# the usermod call asks for a Password:
