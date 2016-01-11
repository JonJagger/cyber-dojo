#!/bin/bash

# parameters
files_path=$1
image_name=$2
max_seconds=$3

# local variables
cidfile=`mktemp --tmpdir=/tmp cyber-dojo.XXXXX`
kill=9

# - - - - - - - - - - - - - -
# run avatar's test in host container

rm --force ${cidfile}

timeout --signal=${kill} $((max_seconds+5))s \
  docker run \
    --cidfile="${cidfile}" \
    --user=www-data \
    --net=none \
    --volumes-from="cyber-dojo-katas-data-container" \
    --workdir=${files_path}  \
    ${image_name} \
    /bin/bash -c "timeout --signal=${kill} $((max_seconds))s ./cyber-dojo.sh 2>&1" 2>/dev/null

exit_status=$?

if [ -f ${cidfile} ]; then
  docker stop       `cat ${cidfile}` &>/dev/null
  docker rm --force `cat ${cidfile}` &>/dev/null
  rm --force ${cidfile}
fi

exit ${exit_status}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# --user=www-data
#
#   The user which runs the cyber-dojo.sh command *inside* the docker container.
#   See comments in languages/C#/NUnit/Dockerfile
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
