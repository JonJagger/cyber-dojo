#!/bin/bash
# Called from lib/docker_machine_runner.rb DockerMachineRunner.run()

# parameters
node_name=$1
sandbox_path=$2
container_name=$3
max_seconds=$4

# local variables
tmp_name=`uuidgen`
kill=9

# - - - - - - - - - - - - - -
# 1. scp avatar's files to the node
# This relies on /tmp/cyber-dojo on the target node having the right
# sticky-bit settings so files created underneath /tmp/cyber-dojo
# can be seen by the www-data user (the --user in docker run)
#
#    $ ...ON THE NODE...
#    $ cd /tmp
#    $ mkdir cyber-dojo
#    $ chmod 777 cyber-dojo
#    $ chown www-data:www-data cyber-dojo
#    $ chmod g+rwsx cyber-dojo
#    $ apt-get install -y acl
#    $ setfacl -d -m group:www-data:rwx cyber-dojo
#    $ setfacl    -m group:www-data:rwx cyber-dojo

docker-machine scp -r ${sandbox_path} ${node_name}:/tmp/cyber-dojo/${tmp_name}/

# - - - - - - - - - - - - - -
# 2. run avatar's test in node's container

eval "$(docker-machine env ${node_name})"

docker run \
  --rm \
  --user=www-data \
  --net=none \
  --volume=/tmp/cyber-dojo/${tmp_name}:/sandbox:rw \
  --workdir=/sandbox  \
  ${container_name} \
  /bin/bash -c "timeout --signal=${kill} ${max_seconds}s ./cyber-dojo.sh 2>&1"

exit_status=$?

# - - - - - - - - - - - - - -
# 3. scp avatar's files back from the node?
# Turned off because not yet needed (eg in Approval style tests)
# Note this script is being run as cyber-dojo user (not www-data)

# - - - - - - - - - - - - - -
# 4. remove avatar's files from the node

docker-machine ssh ${node_name} -- sudo rm -rf /tmp/cyber-dojo/${tmp_name} &

exit ${exit_status}

