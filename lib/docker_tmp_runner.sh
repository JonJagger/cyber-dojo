#!/bin/sh

# Called from lib/docker_tmp_runner.rb DockerTmpRunner.run()
# See stdout-compature comments in lib/host_shell.rb
# http://blog.extracheese.org/2010/05/the-tar-pipe.html
# See sudo comments in docker/web/Dockerfile

SRC_DIR=$1     # Where source files are
IMAGE=$2       # What they'll run in, eg cyberdojofoundation/gcc_assert
MAX_SECS=$3    # How long they've got, eg 10

SUDO='sudo -u docker-runner sudo'

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 1. Start the container running
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# --detach       ; get the CID for [sleep && docker rm] before [docker exec]
# --interactive  ; we tar-pipe later
# --net=none     ; for security
# --user=nobody  ; for security
# Note that the --net=none setting in inherited by [docker exec]

CID=$(${SUDO} docker run --detach \
                         --interactive \
                         --net=none \
                         --user=nobody ${IMAGE} sh)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 2. Tar-pipe the src-files into the container's sandbox
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# The existing C#-NUnit image picks up HOME from the *current* user.
# By default, nobody's entry in /etc/passwd is
#     nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
# and nobody does not have a home dir.
# I usermod to solve this.
#
# Has to be interactive for the tar-pipe.
# The tar-pipe has to be this...
#   (cd ${SRC_DIR} && tar -zcf - .)         | ${SUDO} docker exec ...
# it cannot be this...
#                     tar -zcf - ${SRC_DIR} | ${SUDO} docker exec ...
# because that would retain the path of each file.
#
# On Alpine-linux usermod is not installed by default.
# It's in the shadow package. See docker/language-base for
# ongoing work to get the usermode call to work in new Alpine
# based language-images too.
#
# The existing F#-NUnit cyber-dojo.sh names the /sandbox folder
# So TMP_DIR has to be /sandbox for backward compatibility

SANDBOX=/sandbox

(cd ${SRC_DIR} && tar -zcf - .) \
  | ${SUDO} docker exec \
                   --user=root \
                   --interactive \
                   ${CID} \
                   sh -c "mkdir ${SANDBOX} \
                       && tar -zxf - -C ${SANDBOX} \
                       && chown -R nobody ${SANDBOX} \
                       && usermod --home ${SANDBOX} nobody"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 3. After max_seconds, stop the container
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# The zombie process this backgrounded task creates is reaped by tini.
# See docker/web/Dockerfile

(sleep ${MAX_SECS} && ${SUDO} docker stop ${CID}) &

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 4. Run cyber-dojo.sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

${SUDO} docker exec \
               --user=nobody \
               ${CID} \
               sh -c "cd ${SANDBOX} && ./cyber-dojo.sh 2>&1"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 5. Don't retrieve or use the exit-status of cyber-dojo.sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Using it to determine red/amber/green status is unreliable
#   o) not all test frameworks set their exit-status
#   o) cyber-dojo.sh is editable (suppose it ended [exit 137])

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 6. If the container isn't running, the sleep woke and stopped it
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

RUNNING=$(${SUDO} docker inspect --format="{{ .State.Running }}" ${CID})
if [ "${RUNNING}" != "true" ]; then
  ${SUDO} docker rm --force ${CID}
  exit 137 # (128=timed-out) + (9=killed)
else
  # Tar-pipe the *everything* out of the container's sandbox
  ${SUDO} docker exec \
                 --user=root \
                 --interactive \
                 ${CID} \
                 sh -c "cd ${SANDBOX} && tar -zcf - ." \
    | (cd ${SRC_DIR} && tar -zxf - .)

  ${SUDO} docker rm --force ${CID} > /dev/null
  exit 0
fi
