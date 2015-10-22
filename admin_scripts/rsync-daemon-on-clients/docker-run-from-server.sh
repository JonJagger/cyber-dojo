# parameters

nodeName=machine-node-$1
kataId=5D713F8675
avatarName=alligator
containerName=cyberdojofoundation/clang-3.6.1_assert

# local variables

ipNode=`docker-machine ip ${nodeName}`
outerId=${kataId:0:2}
innerId=${kataId:2:8}
tmpName=`uuidgen`

# - - - - - - - - - - - - - -
# 1. rsync avatar's files to node

rsync \
  --archive \
  --password-file=/var/www/rsyncd.password \
  /var/www/cyber-dojo/katas/${outerId}/${innerId}/${avatarName}/sandbox/ \
  cyber-dojo@${ipNode}::tmp/${tmpName}

# - - - - - - - - - - - - - -
# 2. run avatar's test on node

eval "$(docker-machine env ${nodeName})"
docker run \
  --rm \
  --user=www-data \
  --net=none \
  --volume=/tmp/${tmpName}:/sandbox:rw \
  --workdir=/sandbox  \
  ${containerName} \
  /bin/bash -c 'timeout --signal=9 10s ./cyber-dojo.sh 2>&1'

# - - - - - - - - - - - - - -
# 3. rsync avatar's files back from node

rsync \
  --archive \
  --password-file=/var/www/rsyncd.password \
  cyber-dojo@${ipNode}::tmp/${tmpName}/ \
  /var/www/cyber-dojo/katas/${outerId}/${innerId}/${avatarName}/sandbox

# - - - - - - - - - - - - - -
# 4. remove temporary files on node

docker-machine ssh ${nodeName} -- sudo rm -rf /tmp/${tmpName} &

