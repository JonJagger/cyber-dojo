FROM alpine:3.2
MAINTAINER Jon Jagger <jon@jaggersoft.com>

# The rails app runs docker run/exec commands as the cyber-dojo user
# (the --user=nobody but that is the user *inside* the run/exec container)
#
# Practice session files are stored in katas/...
# and the rails app writes to katas/...
#
# 1. if katas is a folder on host (volume-mounted in the docker-compose yml file)
#    then the rails app on the inside needs to match uid with the cyber-dojo user
#    that owns the katas on the host on the outside (default on Docker-Quickstart-Terminal).
#       $ docker-machine ssh default
#       $ sudo adduser -D -H -u 19661 cyber-dojo
#       $ sudo chown -R cyber-dojo /usr/src/cyber-dojo/app/katas
#
# 2. if katas is a data-container (volumes_from: in the docker-compose.yml file)
#    then the rails app on the inside needs to match uid with the cyber-dojo user
#    that owns the katas inside the data-container (no dependencies to the host)
#    So make both containers run from an image which has this as a base image.

USER root
# -D=no password, -H=no home directory
# set specific uid for cyber-dojo user in case I ever want to volume-mount
# katas/... folder in which case host will need to co-operate.
RUN adduser -D -H -u 19661 cyber-dojo
