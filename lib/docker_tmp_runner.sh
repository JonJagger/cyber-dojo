#!/bin/sh
# Called from lib/docker_tmp_runner.rb DockerTmpRunner.run()
# Also See comments in lib/host_shell.rb
# http://blog.extracheese.org/2010/05/the-tar-pipe.html

FILES_PATH=$1     # Where source files have been saved to
IMAGE=$2          # eg cyberdojofoundation/gcc_assert
MAX_SECONDS=$3    # eg 10

# 1. Start the container running
# --detach; get the CID for [sleep && docker rm] before [docker exec]
# --interactive; we tar-pipe later
# --net=none for security
# --user=nobody for security
CID=$(sudo docker run --detach \
                      --interactive \
                      --net=none \
                      --user=nobody $IMAGE sh)

# 2. After max_seconds, remove the container.
(sleep $MAX_SECONDS && sudo docker rm --force $CID) &

# 3. Tar pipe files into the container and run cyber-dojo.sh
(cd $FILES_PATH && tar -cf - .) \
  | sudo docker exec --interactive \
                     --user=nobody \
      $CID \
      sh -c "mkdir /tmp/cyber-dojo \
          && cd /tmp/cyber-dojo \
          && tar -xf - -C . \
          && ./cyber-dojo.sh 2>&1"
EXIT_STATUS=$?

# 4. If the container isn't running, the sleep woke and removed it
RUNNING=$(sudo docker inspect --format="{{ .State.Running }}" $CID)
if [ "$RUNNING" != "true" ]; then
  exit 137 # (128=timed-out) + (9=killed)
else
  exit $EXIT_STATUS
fi