# parameters
# $1 = 00,01,02

node=machine-node-$1

ipNode=`docker-machine ip ${node}`

kataId=5D713F8675
avatar=alligator
outerId=${kataId:0:2}
innerId=${kataId:2:8}
tmpName=`uuidgen`
user=www-data

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 1. rsync the avatar's sandbox to a tmp folder on the node

export RSYNC_PASSWORD=password

rsync \
  -rtW \
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
  /bin/bash -c 'timeout --signal=9 10s ./cyber-dojo.sh 2>&1; rm -rf /sandbox/*'

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 3. Delete the tmp folder on the node.
# The docker run command above finishes by deleting the *content* of
# the sandbox but it cannot rmdir the sandbox itself because the
# volume-mount is still live.
#
# See setup-tmpreaper.txt for an alternative
#
# Note that if and when files can come *back* from the node
# (eg approval style testing) then the 'rm -rf...' will have
# to be removed from the docker run command

docker-machine ssh ${node} -- sudo rmdir /tmp/${tmpName} &
