#!/bin/sh

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Called from lib/docker_tmp_runner.rb
# NB:
# - the timeout call is in Ubuntu bash syntax *NOT* in Alpine sh syntax.
# - the shell used is /bin/bash
# These decisions are deliberate and explained at length in
# .../languages/alpine_base/_docker_context/timeout
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

FILES_PATH=$1
IMAGE_NAME=$2
MAX_SECONDS=$3

USER=www-data
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
#   On the new docker-in-docker server I initially tried a tmp-data-container
#   (with a /tmp volume) like this...
#       --volumes-from=tmp_data_container
#       --workdir=/tmp/cyber-dojo.23456765
#   where 23456765 was a random id and the source files had been copied into
#   /tmp/cyber-dojo.23456765  This worked but was flawed since inside the
#   docker-run you had access not just to /tmp/cyber-dojo.23456765 but also
#   to /tmp/ Thus you could have done a [rm -rf /tmp/*] in your cyber-dojo.sh
#   file and interfered with *all* concurrent runs.
#
#   The web-container cannot do a docker-run command with a regular volume-mount
#   of /tmp where /tmp is a folder existing only *inside* the web-container.
#
#   The web-container can do a docker-run command with a regular volume-mount
#   of /tmp where /tmp is a folder volume-mounted into it from the *host*.
#
#   The reason for this restruction is that the lifetime of the launching
#   docker-container is *not* bound to the lifetime of its launched docker-container.
#   They are all really just processes on the host.
#
#   Thus /tmp must exist on the *host* and be volume mounted into the web-container
#   and then this script (run from inside the web-container) itself volume mounts
#   an *isolated* sub-folder of /tmp.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
