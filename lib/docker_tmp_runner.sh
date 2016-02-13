#!/bin/bash

# Called from lib/docker_tmp_runner.rb DockerTmpRunner.run()
# See comments in lib/host_shell.rb

FILES_PATH=$1     # where source files have been saved to
IMAGE=$2          # eg cyberdojofoundation/gcc_assert
MAX_SECONDS=$3    # eg 10

TAR_PATH=`mktemp`.tgz          # source files from $FILES_PATH are tarred into this
TMP_PATH=/tmp/cyber-dojo       # where source files are untarred to to inside test container
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
# tar [-] means get input from the catted tar-file
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

# after 10 seconds, forcibly shut down the container
(sleep $MAX_SECONDS && docker rm --force $CID &> /dev/null) &

# run cyber-dojo.sh as user=nobody
# the 2>&1 redirect captures compilation failure output
docker exec --user=$USER $CID sh -c "cd $TMP_PATH && ./cyber-dojo.sh 2>&1"
EXIT_STATUS=$?

# https://gist.github.com/ekristen/11254304
# if the container is not still running then the timeout killed it
RUNNING=$(docker inspect --format="{{ .State.Running }}" $CID)
if [ "$RUNNING" != "true" ]; then
  EXIT_STATUS=137 # (128=timed-out) + (9=killed)
fi

exit $EXIT_STATUS
