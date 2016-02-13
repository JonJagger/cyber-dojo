#!/bin/sh

# Called from lib/docker_katas_runner.rb DockerKatasRunner.run()

FILES_PATH=$1
IMAGE_NAME=$2
MAX_SECONDS=$3

USER=$4  # ???????????

CIDFILE=`mktemp`
KILL=9
SANDBOX=/sandbox

rm -f ${CIDFILE}

timeout --signal=${KILL} $((MAX_SECONDS+5))s \
  docker run \
    --cidfile="${CIDFILE}" \
    --user=${USER} \
    --net=none \
    --volume=${FILES_PATH}:${SANDBOX}:rw \
    --workdir=${SANDBOX} \
    ${IMAGE_NAME} \
    /bin/bash -c "timeout --signal=${KILL} $((MAX_SECONDS))s ./cyber-dojo.sh 2>&1" 2>/dev/null

EXIT_STATUS=$?

if [ -f ${CIDFILE} ]; then
  docker stop       `cat ${CIDFILE}` &>/dev/null
  docker rm --force `cat ${CIDFILE}` &>/dev/null
  rm -f ${CIDFILE}
fi

exit ${EXIT_STATUS}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# --user=www-data
#
#   The user which runs the cyber-dojo.sh command *inside* the languages' container.
#   See also comments in languages/C#/NUnit/Dockerfile
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# --cidfile="${CIDFILE}"
#
#   The cidfile must *not* exist before the docker command is run.
#   Thus I rm the cidfile *before* the docker run.
#   After the docker run I retrieve the docker container's pid
#   from the cidfile and stop and remove the container.
#   Explicitly specifying the cidfile like this (and not using the
#   docker --rm option) ensures the docker container is always killed,
#   even if the timeout occurs.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# --volume=${FILES_PATH}:/sandbox:rw
#
#   On the new docker-in-docker server I initially tried a katas-data-container
#   (with a /katas volume) like this...
#
#       --volumes-from=katas_data_container
#       --workdir=/katas/9A/D3F65020/whale/sandbox:/sandbox
#
#   This worked but was flawed since inside the docker run you had access
#   not just to /katas/9A/D3F65020/whale/sandbox but to *all* of /katas
#   Thus you could have done a [rm -rf /katas/*] in your cyber-dojo.sh
#   file and wiped all the practice sessions.
#
#   The web-container *cannot* do a regular volume-mount of /katas
#   where /katas is a folder existing only *inside* the web-container.
#        --volume=/katas/9A/D3F65020/whale/sandbox:/sandbox:rw  FAILS
#
#   Why not? In docker-in-docker, the lifetime of the launching docker-container
#   is *not* bound to the lifetime of its launched docker-container.
#   They are all really just processes on the host.

#   The web-container *can* do a regular volume-mount of /katas
#   where /tmp is a folder volume-mounted into it from the *host*.
#        --volume=/katas/9A/D3F65020/whale/sandbox:/sandbox:rw  OK
#
#   So the katas/ folder must exist on the *host* and be volume mounted into
#   the 'outer' container.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
