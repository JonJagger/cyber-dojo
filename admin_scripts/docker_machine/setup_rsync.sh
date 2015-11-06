#!/bin/bash

# This has to be run as cyber-dojo user
if [ $(whoami) != 'cyber-dojo' ]; then
  cmd="sudo -u cyber-dojo ${0} $*"
  echo $cmd
  $cmd
  exit
fi

if [ -z "$1" ]; then
  echo "${0} <NODE>"
  exit
fi

node=$1

dm_folder=/var/www/cyber-dojo/admin_scripts/docker_machine

# install /etc/rsyncd.secrets
docker-machine scp $dm_folder/rsyncd.secrets $node:/home/docker-user/rsyncd.secrets
docker-machine ssh $node -- sudo chown root:root /home/docker-user/rsyncd.secrets
docker-machine ssh $node -- sudo chmod 400 /home/docker-user/rsyncd.secrets
docker-machine ssh $node -- sudo mv /home/docker-user/rsyncd.secrets /etc

# install /etc/rsyncd.conf
docker-machine scp $dm_folder/rsyncd.conf    $node:/home/docker-user/rsyncd.conf
docker-machine ssh $node -- sudo chown root:root /home/docker-user/rsyncd.conf
docker-machine ssh $node -- sudo chmod 400 /home/docker-user/rsyncd.conf
docker-machine ssh $node -- sudo mv /home/docker-user/rsyncd.conf /etc

# setup rsync daemon
docker-machine ssh $node -- sudo sed -i 's/RSYNC_ENABLE=false/RSYNC_ENABLE=true/' /etc/init.d/rsync
docker-machine ssh $node -- sudo rsync --daemon

# port 873 needs to be opened on GCE browser network-page


