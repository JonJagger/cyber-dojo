#!/bin/sh

# Called from lib/docker_tmp_runner.rb DockerTmpRunner.run()
# Also See comments in lib/host_shell.rb
#
# The docker run/exec commands all use sh and not bash because
# the web container is based off Alpine based which doesn't have bash.
# UPDATE: That's no longer true. I've installed bash since the test
# scripts are all bash based. But no harm in using sh.

FILES_PATH=$1     # Where source files have been saved to
IMAGE=$2          # eg cyberdojofoundation/gcc_assert
MAX_SECONDS=$3    # eg 10

USER=nobody               # user who runs cyber-dojo.sh inside test container
TMP_PATH=/tmp/cyber-dojo  # Where source files are untarred to to inside test container

# 1. Run the container
# --detached so we can follow with exec's
# --interactive because we pipe the tar file in
# --net=none for security
# --user=nobody for security
CID=$(sudo docker run \
  --detach \
  --interactive \
  --net=none \
  --user=$USER \
    $IMAGE sh)

# 2. Tar pipe the source files into the container
# http://blog.extracheese.org/2010/05/the-tar-pipe.html
# --user=root means root *inside* the container so it can chown

(cd $FILES_PATH && tar -cf - .) \
  | sudo docker exec \
      --interactive \
      --user=root \
      $CID \
      sh -c \
        "mkdir $TMP_PATH \
      && tar -xf - -C $TMP_PATH \
      && chown -R $USER $TMP_PATH"

# 3. After max_seconds, forcibly shut down the container.
(sleep $MAX_SECONDS && sudo docker rm --force $CID &> /dev/null) &

# 4. Run cyber-dojo.sh in the container as user=nobody
# The 2>&1 redirect captures compilation failure output
sudo docker exec --user=$USER $CID sh -c "cd $TMP_PATH && ./cyber-dojo.sh 2>&1"
EXIT_STATUS=$?

# 5. If the container isn't running, the sleep process killed it
# https://gist.github.com/ekristen/11254304
RUNNING=$(docker inspect --format="{{ .State.Running }}" $CID)
if [ "$RUNNING" != "true" ]; then
  EXIT_STATUS=137 # (128=timed-out) + (9=killed)
fi

exit $EXIT_STATUS
