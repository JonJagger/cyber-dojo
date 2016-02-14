#!/bin/sh

# Called from lib/docker_tmp_runner.rb DockerTmpRunner.run()
# Also See comments in lib/host_shell.rb
#
# The docker run/exec commands use sh not bash because the web
# container is Alpine-linux based which doesn't have bash.
# UPDATE: That's no longer true. The test scripts are all bash
# based to I've installed bash. But no harm in using sh.

FILES_PATH=$1     # Where source files have been saved to
IMAGE=$2          # eg cyberdojofoundation/gcc_assert
MAX_SECONDS=$3    # eg 10

USER=nobody               # user who runs cyber-dojo.sh inside container
TMP_PATH=/tmp/cyber-dojo  # Where user runs cyber-dojo.sh inside container

# 1. Start the container running
# --detached so we can follow with exec
# --interactive because we tar pipe into it
# --net=none for security
# --user=nobody for security
CID=$(sudo docker run \
  --detach \
  --interactive \
  --net=none \
  --user=$USER \
    $IMAGE sh)

# 2. After max_seconds, forcibly shut down the container.
(sleep $MAX_SECONDS && sudo docker rm --force $CID &> /dev/null) &

# 3. Tar pipe files into the container and run cyber-dojo.sh as user=nobody
# http://blog.extracheese.org/2010/05/the-tar-pipe.html
# 2>&1 captures compilation failure output
(cd $FILES_PATH && tar -cf - .) \
  | sudo docker exec \
      --interactive \
      --user=$USER \
      $CID \
      sh -c \
        "mkdir $TMP_PATH \
      && cd $TMP_PATH \
      && tar -xf - -C . \
      && ./cyber-dojo.sh 2>&1"

# 4. If the container isn't running, the sleep woke and killed it
# https://gist.github.com/ekristen/11254304
EXIT_STATUS=$?
RUNNING=$(docker inspect --format="{{ .State.Running }}" $CID)
if [ "$RUNNING" != "true" ]; then
  EXIT_STATUS=137 # (128=timed-out) + (9=killed)
fi

exit $EXIT_STATUS
