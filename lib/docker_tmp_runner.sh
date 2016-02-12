#!/bin/sh

# Called from lib/docker_tmp_runner.rb DockerTmpRunner.run()

FILES_PATH=$1
IMAGE=$2
MAX_SECONDS=$3

TAR_PATH=`mktemp`.tgz
TMP_PATH=/tmp/cyber-dojo
USER=nobody

cd $FILES_PATH
tar -zcf $TAR_PATH .

CID=$(docker run \
  --detach \
  --interactive \
  --net=none \
  --user=$USER \
    $IMAGE sh)

cat $TAR_PATH \
  | docker exec \
      --interactive \
      --user=root \
      $CID \
      sh -c \
        "mkdir $TMP_PATH \
      && tar zxf - -C $TMP_PATH \
      && chown -R $USER $TMP_PATH"

rm $TAR_PATH

shut_down_container()
{
  docker kill $CID &> /dev/null
  docker rm --force $CID &> /dev/null
}

(sleep $MAX_SECONDS && shut_down_container) &
TIMEOUT_PID=$!
# Without the 2>&1 redirect output from compilation failures will be lost.
docker exec --user=$USER $CID sh -c "cd $TMP_PATH && ./cyber-dojo.sh 2>&1"
EXIT_STATUS=$?


#https://gist.github.com/ekristen/11254304
RUNNING=$(docker inspect --format="{{ .State.Running }}" $CID)
if [ "${RUNNING}" == "true" ]; then
  kill -9 $TIMEOUT_PID
  shut_down_container
else
  EXIT_STATUS=137
fi

exit $EXIT_STATUS
