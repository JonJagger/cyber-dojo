#!/bin/bash

# Simple script to help see which node a docker-run command ran in

readarray -t nodes <<<"$(sudo -u cyber-dojo docker-machine ls -q)"
for node in "${nodes[@]}"
do
  echo "----------"
  echo $node
  sudo -u cyber-dojo docker-machine ssh "$node" -- sudo tail -1 /var/log/rsyncd.log
done
echo

