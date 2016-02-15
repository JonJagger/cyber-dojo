#!/bin/sh
set -e

KATAS_DIR=$1                  # where katas are copied from on host
CYBER_DOJO_KATAS_ROOT=$2      # where they are copied to in image

CONTEXT_DIR=${KATAS_DIR}

# if KATAS_DIR != KATAS_DEFAULT check KATAS_DIR exists (like cyber-dojo script)
# On OSX Docker-Quickstart-Terminal this script has to run on defult
# docker-machine scp it?

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

pushd ${MY_DIR} > /dev/null

cp ./Dockerfile ${CONTEXT_DIR}

docker build \
  --build-arg=KATAS_DIR=${KATAS_DIR} \
  --tag=cyberdojofoundation/${PWD##*/} \
  --file=${CONTEXT_DIR}/Dockerfile \
  ${CONTEXT_DIR}

rm ${CONTEXT_DIR}/Dockerfile

popd > /dev/null
