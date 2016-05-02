#!/bin/sh

# A runner whose access to the avatar's source files is via a data-container
# containing files for *all* katas/... sub folders.
# The tar-piping is to isolate the avatar's sub-dir in the katas-data-container.

SRC_DIR=$1     # Where the source files are
IMAGE=$2       # What they'll run in, eg cyberdojofoundation/gcc_assert
MAX_SECS=$3    # How long they've got, eg 10
SUDO=$4        # sudo incantation for docker commands

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 1. Start the container running
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# --detach       ; get the CID for [sleep && docker rm] before [docker exec]
# --interactive  ; we tar-pipe later
# --net=none     ; for security
# --user=nobody  ; for security
# Note that the --net=none setting is inherited by [docker exec]

CID=$(${SUDO} docker run --detach \
                         --interactive \
                         --net=none \
                         --user=nobody \
                         ${IMAGE} sh)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 2. Tar-pipe the src-files into the container's sandbox
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# http://blog.extracheese.org/2010/05/the-tar-pipe.html
#
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
# ongoing work to get the usermod call to work in new Alpine
# based language-images too.
#
# The existing F#-NUnit cyber-dojo.sh names the /sandbox folder
# So SANDBOX has to be /sandbox for backward compatibility.
# F#-NUnit is the only cyber-dojo.sh that names /sandbox.
#
# The LHS end of the pipe...
#    [tar -zcf] means create a compressed tar file
#    [-] means don't write to a named file but to STDOUT
#    [.] means tar the current directory
#    which is why there's a preceding cd
#
# The RHS end of the pipe...
#    [tar -zxf] means extract files from the compressed tar file
#    [-] means don't read from a named file but from STDIN
#    [-C ${SANDBOX}] means save the extracted files to the ${SANDBOX} directory
#    which is why there's a preceding mkdir

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
# 3. After max_seconds, remove the container
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Doing [docker stop ${CID}] is not enough to stop a container
# that is printing in an infinite loop.
# Any zombie processes this backgrounded process creates are reaped by tini.
# See docker/web/Dockerfile
# The parentheses put the commands into a child process.
# The & backgrounds it

(sleep ${MAX_SECS} && ${SUDO} docker rm --force ${CID} &> /dev/null) &
SLEEP_DOCKER_RM_PID=$!

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 4. Run cyber-dojo.sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

OUTPUT=$(${SUDO} docker exec \
               --user=nobody \
               --interactive \
               ${CID} \
               sh -c "cd ${SANDBOX} && ./cyber-dojo.sh 2>&1")

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 5. Don't use the exit-status of cyber-dojo.sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Using it to determine red/amber/green status is unreliable
# o) not all test frameworks set their exit-status properly
# o) cyber-dojo.sh is editable (suppose it ended [exit 137])

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 6. If the sleep-docker-rm process is still alive race to kill it
#    before it does [docker rm ${CID}]
#    pkill == kill processes, -P PID == whose parent pid is PID
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pkill -P ${SLEEP_DOCKER_RM_PID}
if [ "$?" != "0" ]; then
  # Failed to kill the sleep-docker-rm process
  # Assume [docker rm ${CID}] happened
  ${SUDO} docker rm --force ${CID} &> /dev/null # belt and braces
  exit 137 # (128=timed-out) + (9=killed)
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 7. Check that CID container is still running (belt and braces)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

RUNNING=$(${SUDO} docker inspect --format="{{ .State.Running }}" ${CID})
if [ "${RUNNING}" != "true" ]; then
  exit 137 # (128=timed-out) + (9=killed)
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 8. The container completed and is still running
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# o) Echo the output so it can be red/amber/green regex'd (see 5)
# o) Tar-pipe *everything* out of the run-container's sandbox back to SRC_DIR
# o) Remove the container.
#
# When this runs it outputs the following diagnostic to stdout/stderr
#    tar: .: Not found in archive
#    tar: Error exit delayed from previous errors.
# As best I can tell this is because of the . in one of the tar-commands
# and refers the dot as in the current directory. It seems to be harmless.
# The files are tarred back, are saved, are git commited, and git diff works.

echo "${OUTPUT}"

${SUDO} docker exec \
               --user=root \
               --interactive \
               ${CID} \
               sh -c "cd ${SANDBOX} && tar -zcf - ." \
               | (cd ${SRC_DIR} && tar -zxf - .)

${SUDO} docker rm --force ${CID} &> /dev/null

exit 0
