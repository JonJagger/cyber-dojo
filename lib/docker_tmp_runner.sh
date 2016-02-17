#!/bin/sh

# Called from lib/docker_tmp_runner.rb DockerTmpRunner.run()
# See stdout-compature comments in lib/host_shell.rb
# http://blog.extracheese.org/2010/05/the-tar-pipe.html
# See sudo comments in web Dockerfile

SRC_DIR=$1     # Where source files are
IMAGE=$2       # What they'll run in, eg cyberdojofoundation/gcc_assert
MAX_SECS=$3    # How long they've got, eg 10

SUDO='sudo -u docker-runner sudo'

# - - - - - - - - - - - - - - - - - - - - - -
# 1. Start the container running
#
# --detach       ; get the CID for [sleep && docker rm] before [docker exec]
# --interactive  ; we tar-pipe later
# --net=none     ; for security
# --user=nobody  ; for security
# Note that the --net=none setting in inherited by [docker exec]

CID=$(${SUDO} docker run --detach \
                         --interactive \
                         --net=none \
                         --user=nobody ${IMAGE} sh)

# - - - - - - - - - - - - - - - - - - - - - -
# 2. Tar pipe the files into the container
#
# The existing C#-NUnit Dockerfile has (and requires) this
#
# RUN usermod -m -d /home/www-data www-data
# RUN mkdir /home/www-data
# RUN chgrp www-data /home/www-data
# RUN chown www-data /home/www-data
# ENV HOME /home/www-data
#
# When NUnit runs it picks up HOME from the *current* user.
# So this will not work when run by docker_tmp_runner.sh as nobody
# since by default, on Alpine, nobody's entry in /etc/passwd is
#     nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
# and nobody does not have a home dir.
# I usermod to solve this.
# Has to be interactive for the tar-pipe.

TMP_DIR=/tmp/cyber-dojo

(cd ${SRC_DIR} && tar -cf - .) \
  | ${SUDO} docker exec \
                   --user=root \
                   --interactive \
                   ${CID} \
                   sh -c "mkdir ${TMP_DIR} \
                       && cd ${TMP_DIR} \
                       && tar -xf - -C . \
                       && chown -R nobody ${TMP_DIR} \
                       && usermod --home ${TMP_DIR} nobody"

# - - - - - - - - - - - - - - - - - - - - - -
# 3. After max_seconds, remove the container
#
# The zombie process this backgrounded task creates is reaped by tini.
# See rails server's Dockerfile

(sleep ${MAX_SECS} && ${SUDO} docker rm --force ${CID}) &

# - - - - - - - - - - - - - - - - - - - - - -
# 4. Run cyber-dojo.sh
#
# I do not retrieve the exit-status of cyber-dojo. Using that to determine
# red/amber/green status is not feasible, partly because cyber-dojo.sh is
# editable (suppose it ended [exit 137])

${SUDO} docker exec \
               --user=nobody \
               ${CID} \
               sh -c "cd ${TMP_DIR} && ./cyber-dojo.sh 2>&1"

# - - - - - - - - - - - - - - - - - - - - - -
# 5. If the container isn't running, the sleep woke and removed it

RUNNING=$(${SUDO} docker inspect --format="{{ .State.Running }}" ${CID})
if [ "${RUNNING}" != "true" ]; then
  exit 137 # (128=timed-out) + (9=killed)
else
  exit 0
fi
