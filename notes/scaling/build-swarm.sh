#!/bin/bash

# Script used in early investigation of using docker-swarm
# to scale cyber-dojo. Currently hard-wires the number
# of nodes (2) and the node-region (London) and the node-size (2gb)
# It will make sense to spread the nodes across the world.

# Important this is run as the user who will run the
# [docker run] command in lib/DockerGitCloneRunner.rb
# which is cyber-dojo

if [ $# -eq 0 ]; then
  echo "use: scale [digital-ocean-access-token]"
  exit 1
else
  digitalOceanAccessToken=$1
fi

swarmToken=`docker run --rm swarm create`
echo swarm-token $swarmToken created
echo $swarmToken > ~/docker-swarm.token

# - - - - - - - - - - - - - - - - - - - - - - -
# Clear out nodes if they already exist

docker-machine rm -f cyber-dojo-docker-swarm-master  2>&1 > /dev/null
docker-machine rm -f cyber-dojo-docker-swarm-node-00 2>&1 > /dev/null
docker-machine rm -f cyber-dojo-docker-swarm-node-01 2>&1 > /dev/null

# - - - - - - - - - - - - - - - - - - - - - - -
# Create the swarm-master

docker-machine create \
   --driver digitalocean \
   --digitalocean-access-token=$digitalOceanAccessToken \
   --digitalocean-region=lon1 \
   --digitalocean-size=1gb \
   --swarm \
   --swarm-master \
   --swarm-discovery token://$swarmToken \
   cyber-dojo-docker-swarm-master

if [ $? -ne 0 ]; then
  echo "FAILED:$ docker-machine create ... cyber-dojo-docker-swarm-master"
  docker-machine rm -f cyber-dojo-docker-swarm-master 2>&1 > /dev/null
  exit 2
else
  echo "OK:$ docker-machine create ... cyber-dojo-docker-swarm-master"
fi

# - - - - - - - - - - - - - - - - - - - - - - -
# Create the first swarm-node

docker-machine create \
   --driver digitalocean \
   --digitalocean-access-token=$digitalOceanAccessToken \
   --digitalocean-region=lon1 \
   --digitalocean-size=2gb \
   --swarm \
   --swarm-discovery token://$swarmToken \
   cyber-dojo-docker-swarm-node-00

if [ $? -ne 0 ]; then
  echo "FAILED:$ docker-machine create ... cyber-dojo-docker-swarm-node-00"
  docker-machine rm -f cyber-dojo-docker-swarm-master  2>&1 > /dev/null
  docker-machine rm -f cyber-dojo-docker-swarm-node-00 2>&1 > /dev/null
  exit 3
else
  echo "OK:$ docker-machine create ... cyber-dojo-docker-swarm-node-00"
fi

# - - - - - - - - - - - - - - - - - - - - - - -
# Create the second swarm-node

docker-machine create \
   --driver digitalocean \
   --digitalocean-access-token=$digitalOceanAccessToken \
   --digitalocean-region=lon1 \
   --digitalocean-size=2gb \
   --swarm \
   --swarm-discovery token://$swarmToken \
   cyber-dojo-docker-swarm-node-01

if [ $? -ne 0 ]; then
  echo "FAILED:$ docker-machine create ... cyber-dojo-docker-swarm-node-01"
  docker-machine rm -f cyber-dojo-docker-swarm-master  2>&1 > /dev/null
  docker-machine rm -f cyber-dojo-docker-swarm-node-00 2>&1 > /dev/null
  docker-machine rm -f cyber-dojo-docker-swarm-node-01 2>&1 > /dev/null
  exit 4
else
  echo "OK:$ docker-machine create ... cyber-dojo-docker-swarm-node-01"
fi

# - - - - - - - - - - - - - - - - - - - - - - -
# Put some images onto both swarm-nodes
# So create page lists some laguages
# and test [docker run] command does need to do a [docker pull]

docker-machine ssh cyber-dojo-docker-swarm-node-00 'docker pull cyberdojo/gcc-4.8.1_assert'
docker-machine ssh cyber-dojo-docker-swarm-node-01 'docker pull cyberdojo/gcc-4.8.1_assert'
