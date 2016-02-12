#!/bin/sh

# Called from lib/docker_tmp_runner.rb DockerTmpRunner.run()

FILES_PATH=$1     # where source files are saved to
IMAGE=$2          # eg cyberdojofoundation/gcc_assert
MAX_SECONDS=$3    # eg 10

TAR_PATH=`mktemp`.tgz          # tar file of the source files in $FILES_PATH
TMP_PATH=/tmp/cyber-dojo       # where source files are copied to inside test container
USER=nobody                    # user who runs cyber-dojo.sh inside test container

# create tar file from source files
cd $FILES_PATH
tar -zcf $TAR_PATH .

# start container
# --interactive because we pipe the tar file in
# --net=none for security
# --user=nobody for security
# sh because alpine doesn't have bash
CID=$(docker run \
  --detach \
  --interactive \
  --net=none \
  --user=$USER \
    $IMAGE sh)

# get the source files into the running container
# --user=root means root *inside* the container so it can chmod
# tar [-] means get input from the cat tar-file
# tar -C PATH means eXtract the tar's files into PATH
# sh because alpine doesn't have bash
# alpine has mkdir, tar, chown
cat $TAR_PATH \
  | docker exec \
      --interactive \
      --user=root \
      $CID \
      sh -c \
        "mkdir $TMP_PATH \
      && tar zxf - -C $TMP_PATH \
      && chown -R $USER $TMP_PATH"

# tar file has done its job so delete it
rm $TAR_PATH

# cyber-dojo.sh runs inside the container. It might complete within 10
# seconds or it might not. Either way the (detached) running container
# has to be shut down.
shut_down_container()
{
  docker kill $CID &> /dev/null
  docker rm --force $CID &> /dev/null
}

# setup a background process that forcibly shuts down the container
# after 10 seconds and remembers the pid of the background proces
(sleep $MAX_SECONDS && shut_down_container) &
TIMEOUT_PID=$!

# run cyber-dojo.sh as user=nobody
# the 2>&1 redirect captures compilation failure output
docker exec --user=$USER $CID sh -c "cd $TMP_PATH && ./cyber-dojo.sh 2>&1"
EXIT_STATUS=$?

# is the time-out background process is still running?
# https://gist.github.com/ekristen/11254304
RUNNING=$(docker inspect --format="{{ .State.Running }}" $CID)
if [ "${RUNNING}" == "true" ]; then
  # yes it is; we didn't time-out so kill the background process
  # and shut down the (detached) container
  SIG_KILL=9
  kill -$SIG_KILL $TIMEOUT_PID
  shut_down_container
else
  # no it's not; it's already shut down the container and exited
  EXIT_STATUS=137 # (128=timed-out) + (9=killed)
fi

# See comments in lib/host_shell.rb
exit $EXIT_STATUS
