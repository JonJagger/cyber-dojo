# parameters
# $1 = 00,01,02

node=machine-node-$1

ipNode=`docker-machine ip ${node}`

kataId=5D713F8675
avatar=alligator
outerId=${kataId:0:2}
innerId=${kataId:2:8}
tmpFolder=`uuidgen`
user=www-data

# rsync the avatar's sandbox to a tmp folder on the node

export RSYNC_PASSWORD=password

rsync \
  -rtW \
  /var/www/cyber-dojo/katas/${outerId}/${innerId}/${avatar}/sandbox/ \
  cyber-dojo@${ipNode}::tmp/${tmpFolder}

unset RSYNC_PASSWORD

# docker run ... cyber-dojo.sh
# Note --net=none
# Note --volume=tmp folder from above

eval "$(docker-machine env ${node})"

docker run \
  --rm \
  --user=${user} \
  --net=none \
  --volume=/tmp/${tmpFolder}:/sandbox:rw \
  --workdir=/sandbox  \
  cyberdojofoundation/clang-3.6.1_assert \
  /bin/bash -c ./cyber-dojo.sh

# delete the tmp folder on the node.
# See setup-tmpreaper.txt for alternative

docker-machine ssh ${node} -- sudo rm -rf /tmp/${tmpFolder}

