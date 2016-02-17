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
# --detach       ; get the CID for [sleep && docker rm] before [docker exec]
# --interactive  ; we tar-pipe later
# --net=none     ; for security
# --user=nobody  ; for security

CID=$(${SUDO} docker run --detach \
                         --interactive \
                         --net=none \
                         --user=nobody ${IMAGE} sh)

# - - - - - - - - - - - - - - - - - - - - - -
# 2. After max_seconds, remove the container

(sleep ${MAX_SECS} && ${SUDO} docker rm --force ${CID}) &

# - - - - - - - - - - - - - - - - - - - - - -
# 3. Tar pipe the files into the container and run cyber-dojo.sh

TMP_DIR=/tmp/cyber-dojo

(cd ${SRC_DIR} && tar -cf - .) \
  | ${SUDO} docker exec --interactive \
                        --user=nobody \
            ${CID} \
            sh -c "mkdir ${TMP_DIR} \
                && cd ${TMP_DIR} \
                && tar -xf - -C . \
                && ./cyber-dojo.sh 2>&1"

# - - - - - - - - - - - - - - - - - - - - - -
# 4. If the container isn't running, the sleep woke and removed it

RUNNING=$(${SUDO} docker inspect --format="{{ .State.Running }}" ${CID})
if [ "${RUNNING}" != "true" ]; then
  exit 137 # (128=timed-out) + (9=killed)
else
  exit 0
fi
