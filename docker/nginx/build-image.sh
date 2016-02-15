#!/bin/sh
set -e

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
CONTEXT_DIR=../../public

pushd ${MY_DIR} > /dev/null

cp ./Dockerfile ${CONTEXT_DIR}
cp ./nginx.conf ${CONTEXT_DIR}

docker build \
  --tag=cyberdojofoundation/${PWD##*/} \
  --file=${CONTEXT_DIR}/Dockerfile \
  ${CONTEXT_DIR}

rm ${CONTEXT_DIR}/Dockerfile
rm ${CONTEXT_DIR}/nginx.conf

popd > /dev/null
