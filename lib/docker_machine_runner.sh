#!/bin/bash

# TODO: needs to be checked in bin/sh

# Called from lib/docker_machine_runner.rb DockerMachineRunner.run()

# parameters
node_name=$1
files_path=$2
image_name=$3
max_seconds=$4

# local variables
tmp_name=`uuidgen`
kill=9

# - - - - - - - - - - - - - -
# 1. scp avatar's files to the node
# This relies on /tmp/cyber-dojo on the target node having the right
# sticky-bit settings for the www-data user (the --user in the docker run)
# I am not sure if these sticky-bit settings need to be on the
# server's /tmp/... folder where the files are copied from, or on the
# node's /tmp/... folder where the files are copied to.
# I did it on both to be sure
#
#    $ ...ON THE SERVER...
#    $ cd /tmp
#    $ chmod 777 .
#    $ chown www-data:www-data .
#    $ chmod g+rwsx .
#    $ apt-get install -y acl
#    $ setfacl -d -m group:www-data:rwx .
#    $ setfacl    -m group:www-data:rwx .
#
#    $ ...ON THE NODES...
#    $ cd /tmp
#    $ mkdir cyber-dojo
#    $ chmod 777 cyber-dojo
#    $ chown www-data:www-data cyber-dojo
#    $ chmod g+rwsx cyber-dojo
#    $ apt-get install -y acl
#    $ setfacl -d -m group:www-data:rwx cyber-dojo
#    $ setfacl    -m group:www-data:rwx cyber-dojo

docker-machine scp -r ${files_path} ${node_name}:/tmp/cyber-dojo/${tmp_name}/

# - - - - - - - - - - - - - -
# 2. run avatar's test in node's container

eval "$(docker-machine env ${node_name})"

docker run \
  --rm \
  --user=www-data \
  --net=none \
  --volume=/tmp/cyber-dojo/${tmp_name}:/sandbox:rw \
  --workdir=/sandbox  \
  ${image_name} \
  /bin/bash -c "timeout --signal=${kill} ${max_seconds}s ./cyber-dojo.sh 2>&1"

exit_status=$?

# - - - - - - - - - - - - - -
# 3. scp avatar's files back from the node?
# Not yet needed (eg in Approval style tests)
# Note this script is being run as cyber-dojo user (not www-data)

# - - - - - - - - - - - - - -
# 4. remove avatar's files from the node. Note background task. Beware zombie processes.

docker-machine ssh ${node_name} -- sudo rm -rf /tmp/cyber-dojo/${tmp_name} &

exit ${exit_status}

