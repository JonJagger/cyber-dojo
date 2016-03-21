#!/bin/bash
set -e

CYBER_DOJO_KATAS_ROOT=$1      # where files are copied to in image. Required.
KATAS_DIR=$2                  # where katas are copied from on host. Optional

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

# - - - - - - - - - - - - - - - - - - - - - - - - - -

build_empty_katas_data_container()
{
  # for building a new server - no existing /var/www/cyber-dojo/katas folder
  #
  # ./build-image.sh /usr/src/cyber-dojo/app/katas

  CONTEXT_DIR=.
  pushd ${MY_DIR} > /dev/null

  # create image
  docker build \
    --build-arg=CYBER_DOJO_KATAS_ROOT=${CYBER_DOJO_KATAS_ROOT} \
    --tag=cyberdojofoundation/${PWD##*/} \
    --file=${CONTEXT_DIR}/Dockerfile \
    ${CONTEXT_DIR}

  # create container
  docker run --name cdf-katas-DATA-CONTAINER cyberdojofoundation/katas echo 'cdfKatasDC'

  popd > /dev/null
}

# - - - - - - - - - - - - - - - - - - - - - - - - - -

build_full_katas_data_container()
{
  # for building a replacement server - an existing /var/www/cyber-dojo/katas folder
  #
  # ./build-image.sh /usr/src/cyber-dojo/app/katas /var/www/cyber-dojo/test/app_models

  # TODO: check KATAS_DIR exists (like cyber-dojo script)
  # On OSX Docker-Quickstart-Terminal this script has to run on defult
  # docker-machine scp it?

  CONTEXT_DIR=${KATAS_DIR}
  pushd ${MY_DIR} > /dev/null
  cp ./Dockerfile    ${CONTEXT_DIR}
  cp ./.dockerignore ${CONTEXT_DIR}

  # create image
  docker build \
    --build-arg=CYBER_DOJO_KATAS_ROOT=${CYBER_DOJO_KATAS_ROOT} \
    --tag=cyberdojofoundation/${PWD##*/} \
    --file=${CONTEXT_DIR}/Dockerfile \
    ${CONTEXT_DIR}

  # create container
  docker run --name cyber-dojo-katas cyberdojofoundation/katas echo 'katas-data-container'

  rm ${CONTEXT_DIR}/Dockerfile
  rm ${CONTEXT_DIR}/.dockerignore
  popd > /dev/null

}

# - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ "${KATAS_DIR}" == "" ]; then
  build_empty_katas_data_container
else
  build_full_katas_data_container
fi

