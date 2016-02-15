FROM alpine:3.2
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# cyber-dojo docker run/exec commands are done as cyber-dojo user
#
# cyber-dojo practice sessions are stored in katas/...
# the cyber-dojo web server runs as cyber-dojo user
# so the cyber-dojo user needs to write to katas/...
#
# 1. if katas is a folder on host and is volume-mounted (in docker-compose yml file)
#    then on the host (default on Docker-Quickstart-Terminal) the katas folder needs
#    to be owned by cyber-dojo uid=19661 as seen on the host.
#       $ docker-machine ssh default
#       $ sudo adduser -D -H -u 19661 cyber-dojo
#       $ sudo chown -R cyber-dojo /usr/src/cyber-dojo/app/katas
#
# 2. if katas is a data-container then the data-container files need
#    to be owned by cyber-dojo user as seen *inside* the container.
#    Simply build the data-container's image FROM this image
#    This has no user dependencies on the host.

USER root
# -D            no password
# -H            no home directory
# -u 19961      user-id=19961
# cyber-dojo    user-name=cyber-dojo
RUN adduser -D -H -u 19661 cyber-dojo

USER cyber-dojo
