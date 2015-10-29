#!/bin/bash

# parameters
node_name=$1
sandbox_path=$2
container_name=$3
max_seconds=$4

# local variables
ip_node=`docker-machine ip ${node_name}`
tmp_name=`uuidgen`
kill=9

# - - - - - - - - - - - - - -
# 1. rsync avatar's files to the node

rsync \
  --archive \
  --password-file=/var/www/rsyncd.password \
  ${sandbox_path} \
  cyber-dojo@${ip_node}::tmp/${tmp_name}

# - - - - - - - - - - - - - -
# 2. run avatar's test in node's container

eval "$(docker-machine env ${node_name})"
docker run \
  --rm \
  --user=www-data \
  --net=none \
  --volume=/tmp/${tmp_name}:/sandbox:rw \
  --workdir=/sandbox  \
  ${container_name} \
  /bin/bash -c "timeout --signal=${kill} ${max_seconds}s ./cyber-dojo.sh 2>&1"

exit_status=$?

# - - - - - - - - - - - - - -
# 3. rsync avatar's files back from the node

rsync \
  --archive \
  --password-file=/var/www/rsyncd.password \
  cyber-dojo@${ip_node}::tmp/${tmp_name}/ \
  ${sandbox_path}

# - - - - - - - - - - - - - -
# 4. remove temporary files from the node

docker-machine ssh ${node_name} -- sudo rm -rf /tmp/${tmp_name} &

exit ${exit_status}

