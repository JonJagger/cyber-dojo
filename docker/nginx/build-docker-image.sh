#!/bin/sh
set -e

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${MY_DIR} > /dev/null

CONTEXT_DIR=../../public

cp ./Dockerfile ${CONTEXT_DIR}
cp ./nginx.conf ${CONTEXT_DIR}

docker build \
  --tag=cyberdojofoundation/nginx \
  --file=${CONTEXT_DIR}/Dockerfile \
  ${CONTEXT_DIR}

rm ${CONTEXT_DIR}/Dockerfile
rm ${CONTEXT_DIR}/nginx.conf

popd > /dev/null
