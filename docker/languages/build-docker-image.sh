#!/bin/bash

ROOT=${1:-/var/www/cyber-dojo}
DIR=languages
MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${MY_DIR} > /dev/null

cp Dockerfile ../../${DIR}

docker build \
  --build-arg CYBER_DOJO_ROOT=${ROOT} \
  --tag cyberdojofoundation/${DIR} \
  ../../${DIR}

EXIT_STATUS=$?

rm ../../${DIR}/Dockerfile

popd > /dev/null

exit ${EXIT_STATUS}
