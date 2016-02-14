#!/bin/sh

# Called from lib/docker_tmp_runner.rb DockerTmpRunner.run()
# Also See comments in lib/host_shell.rb

FILES_PATH=$1     # Where source files have been saved to
IMAGE=$2          # eg cyberdojofoundation/gcc_assert
MAX_SECONDS=$3    # eg 10

TAR_PATH=`mktemp`.tgz          # Source files from $FILES_PATH are tarred into this
TMP_PATH=/tmp/cyber-dojo       # Where source files are untarred to to inside test container
USER=nobody                    # user who runs cyber-dojo.sh inside test container

# The docker run/exec commands all use sh and not bash because
# the web container is based off Alpine based which doesn't have bash.

# Create tar file from source files
cd $FILES_PATH
tar -zcf $TAR_PATH .

# Run the container
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

# Get the source files into the running container
# --user=root means root *inside* the container so it can chmod
# tar [-] means get input from the catted tar-file
# tar -C PATH means eXtract the tar's files into PATH
cat $TAR_PATH \
  | sudo docker exec \
      --interactive \
      --user=root \
      $CID \
      sh -c \
        "mkdir $TMP_PATH \
      && tar zxf - -C $TMP_PATH \
      && chown -R $USER $TMP_PATH"

# Tar file has done its job so delete it
rm $TAR_PATH

# After max_seconds, forcibly shut down the container.
(sleep $MAX_SECONDS && sudo docker rm --force $CID &> /dev/null) &

# Run cyber-dojo.sh as user=nobody
# The 2>&1 redirect captures compilation failure output
sudo docker exec --user=$USER $CID sh -c "cd $TMP_PATH && ./cyber-dojo.sh 2>&1"
EXIT_STATUS=$?

# https://gist.github.com/ekristen/11254304
# If the container isn't running, the sleep process killed it
RUNNING=$(docker inspect --format="{{ .State.Running }}" $CID)
if [ "$RUNNING" != "true" ]; then
  EXIT_STATUS=137 # (128=timed-out) + (9=killed)
fi

exit $EXIT_STATUS
