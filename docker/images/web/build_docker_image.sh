#!/bin/bash

# NB: do not push built image to hub!

pems_in_context=/var/www/cyber-dojo/pems
mkdir -p ${pems_in_context}

pems=(ca cert key)
for pem in ${pems[*]}
do
  pem_file=${pem}.pem
  cp ${DOCKER_CERT_PATH}/${pem_file} ${pems_in_context}
  chmod +r ${pems_in_context}/${pem_file}
done

docker build \
  -t cyberdojofoundation/web \
  -f ./Dockerfile \
  ../../..

rm -rf ${pems_in_context}
