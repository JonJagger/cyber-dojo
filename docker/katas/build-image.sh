#!/bin/sh
set -e

CYBER_DOJO_KATAS_ROOT=$1      # where they are copied to in image. Required.
KATAS_DIR=$2                  # where katas are copied from on host. Optional

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

# - - - - - - - - - - - - - - - - - - - - - - - - - -

build_empty_katas_data_container()
{
  CONTEXT_DIR=.
  pushd ${MY_DIR} > /dev/null

  docker build \
    --build-arg=CYBER_DOJO_KATAS_ROOT=${CYBER_DOJO_KATAS_ROOT} \
    --tag=cyberdojofoundation/${PWD##*/} \
    --file=${CONTEXT_DIR}/Dockerfile \
    ${CONTEXT_DIR}

  docker create --name cyber-dojo-katas cyberdojofoundation/katas
  docker run --rm -it --volumes-from=cyber-dojo-katas cyberdojofoundation/user-base sh

  popd > /dev/null
}

# - - - - - - - - - - - - - - - - - - - - - - - - - -

build_full_katas_data_container()
{
  # check KATAS_DIR exists (like cyber-dojo script)
  # On OSX Docker-Quickstart-Terminal this script has to run on defult
  # docker-machine scp it?

  CONTEXT_DIR=${KATAS_DIR}
  pushd ${MY_DIR} > /dev/null
  #cp ./Dockerfile ${CONTEXT_DIR}

  echo 'pwd'
  pwd
  echo 'ls'
  ls
  echo 'docker build... FULL katas'

  #rm ${CONTEXT_DIR}/Dockerfile
  popd > /dev/null

}

# - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ "${KATAS_DIR}" == "" ]; then
  build_empty_katas_data_container
else
  build_full_katas_data_container
fi



