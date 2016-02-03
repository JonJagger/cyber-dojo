#!/bin/bash

# NB: do not push web image with pems in it to hub!

# Have to copy pem files, temporarily into ${context}/pems
# folder so that they can be copied into the image.
# See also setting in docker/os/osx_yosemite/docker-compose.osx.yml
# web:
#    environment:
#       - DOCKER_CERT_PATH=${CYBER_DOJO_ROOT}/pems


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PEMS_IN_CONTEXT=${DIR}/../../../pems
mkdir -p ${PEMS_IN_CONTEXT}

PEMS=(ca cert key)
for pem in ${PEMS[*]}
do
  pem_file=${pem}.pem
  cp ${DOCKER_CERT_PATH}/${pem_file} ${PEMS_IN_CONTEXT}
  chmod +r ${PEMS_IN_CONTEXT}/${pem_file}
done

pushd ${DIR} > /dev/null

docker build \
  --no-cache \
  --build-arg CYBER_DOJO_ROOT=$1 \
  --tag cyberdojofoundation/web \
  --file ./Dockerfile.osx \
  ../../..

EXIT_STATUS=$?

rm -rf ${PEMS_IN_CONTEXT}

popd > /dev/null

exit ${EXIT_STATUS}