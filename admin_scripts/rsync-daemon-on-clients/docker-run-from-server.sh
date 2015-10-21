# parameters
# $1 = will be name of node chosen at random from runner

node=machine-node-$1
kataId=5D713F8675  # $2
avatar=alligator   # $3

ipNode=`docker-machine ip ${node}`
outerId=${kataId:0:2}
innerId=${kataId:2:8}
tmpName=`uuidgen`
user=www-data

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 1. rsync the avatar's sandbox to a tmp folder on the node

export RSYNC_PASSWORD=password

rsync \
  --archive \
  /var/www/cyber-dojo/katas/${outerId}/${innerId}/${avatar}/sandbox/ \
  cyber-dojo@${ipNode}::tmp/${tmpName}

unset RSYNC_PASSWORD

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 2. docker run ...

eval "$(docker-machine env ${node})"

docker run \
  --rm \
  --user=${user} \
  --net=none \
  --volume=/tmp/${tmpName}:/sandbox:rw \
  --workdir=/sandbox  \
  cyberdojofoundation/clang-3.6.1_assert \
  /bin/bash -c 'timeout --signal=9 10s ./cyber-dojo.sh 2>&1'

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 3. Delete the tmp folder on the node.
# The docker run command above could finish by deleting the *contents* of
# the sandbox like this...
#   /bin/bash -c 'timeout --signal=9 10s ./cyber-dojo.sh 2>&1; rm -rf /sandbox/*'
# but it cannot rmdir /sandbox itself because the volume-mount is still live.
#
# See setup-tmpreaper.txt for an alternative
#
# Note that if and when files can come *back* from the node
# (eg approval style testing) then a second 'reverse' rsync will go here
# before the rm.

docker-machine ssh ${node} -- sudo rm -rf /tmp/${tmpName} &
