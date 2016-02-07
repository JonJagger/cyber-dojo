#!/bin/sh

# Called from lib/docker_from_docker_runner.rb

FILES_PATH=$1
IMAGE_NAME=$2
MAX_SECONDS=$3

CIDFILE=`mktemp`
KILL=9
USER=root

# - - - - - - - - - - - - - -

setfacl -m group:${USER}:rwx ${FILES_PATH}

rm -f ${CIDFILE}

timeout -s ${KILL} -t $((MAX_SECONDS+5)) \
  docker run \
    --cidfile="${CIDFILE}" \
    --user=${USER} \
    --net=none \
    --volumes-from=cyberdojo_tmp_data_container \
    --workdir=${FILES_PATH} \
    ${IMAGE_NAME} \
    sh -c "timeout -s ${KILL} -t $((MAX_SECONDS)) sh -c ./cyber-dojo.sh 2>&1" 2>/dev/null

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
#   The user which runs the cyber-dojo.sh command *inside* the docker container.
#   The setfacl call ensures that inside the container the www-data user has
#   the ability to create files.
#   Relies on www-data's uid on the app (which is running in a docker container)
#   being the same as www-data's uid inside the started container (docker in docker).
#   See also comments in languages/C#/NUnit/Dockerfile
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# --cidfile="${cidfile}"
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
# --volumes-from=cyberdojo_tmp_data_container
#
#   It is not possible to replace this with a straight volume mount of, say, /tmp
#   This is because in a docker-from-docker context, the lifetime of the launching
#   docker-container is *not* bound to the lifetime of the launched docker-container.
#   They are all really just processes on the host.
#   The launching docker-container is not allowed to issue a docker run command which
#   volume-mounts a folder whose lifetime is tied to its own lifetime.
#   Instead the folder must be wrapped in a data-container which exists on the host.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
