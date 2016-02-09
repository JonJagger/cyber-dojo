#!/bin/bash

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HUB=cyberdojofoundation
IMAGES=(nginx web)

HOME=/usr/app/cyber-dojo          # the rails home folder inside web-image

# defaults
RAILS_ENV_DEFAULT=development
RUNNER_DEFAULT=DockerTmpRunner

KATAS=/usr/app/cyber-dojo/katas
RAILS_ENV=${RAILS_ENV_DEFAULT}
RUNNER=${RUNNER_DEFAULT}

# - - - - - - - - - - - - - - - - - - - - - -

ME="$(basename $0)"

function show_use {
  echo "#"
  echo "# ${ME} [clean | reset | build | push | pull]"
  echo "# ${ME} up DEFAULTS"
  echo "#"
  echo "# DEFAULTS"
  echo "# katas=${KATAS}"
  echo "# rails_env=${RAILS_ENV_DEFAULT}"
  echo "# runner=${RUNNER_DEFAULT}"
  echo "#"
  echo "# OPTIONS"
  echo "# rails_env=production"
  echo "# runner=DockerKatasRunner"
  echo ""
}

function exit_if_bad_rails_env {
  if [ "${RAILS_ENV}" != 'development' ] && [ "${RAILS_ENV}" != 'production' ]; then
    echo "# ??? rails_env=${RAILS_ENV}"
    echo "# ${ME} rails_env=development"
    echo "# ${ME} rails_env=production"
    show_use
    exit
  fi
}

function exit_if_bad_katas {
  # TODO: check katas folder exists
  true
}

function exit_if_bad_runner {
  if [ "${RUNNER}" != 'DockerTmpRunner' ] && [ "${RUNNER}" != 'DockerKatasRunner' ]; then
    echo "# ??? runner=${RUNNER}"
    echo "# ${ME} runner=development"
    echo "# ${ME} runner=production"
    show_use
    exit
  fi
}

if [  $# -eq 0 ]; then
  show_use
  exit
fi

# - - - - - - - - - - - - - - - - - - - - - -

function clean {
  # remove containers
  for IMAGE in ${IMAGES[*]}
  do
    docker ps -a \
    | grep ${HUB}/${IMAGE} \
    | awk '{print $1}' \
    | xargs docker rm -f
  done
  # remove untagged images
  docker images -q --filter "dangling=true" | xargs docker rmi
}

# - - - - - - - - - - - - - - - - - - - - - -

function reset {
  # remove existing images
  for IMAGE in ${IMAGES[*]}
  do
    docker rmi -f ${HUB}/${IMAGE} 2&> /dev/null
  done
}

# - - - - - - - - - - - - - - - - - - - - - -

function build {
  pushd ${MY_DIR} > /dev/null
  for IMAGE in ${IMAGES[*]}
  do
    echo ${IMAGE}
    ./${IMAGE}/build-docker-image.sh ${HOME}
    if [ $? -ne 0 ]; then
      echo "BUILDING ${HUB}/${IMAGE} FAILED"
      exit
    fi
  done
  popd > /dev/null
}

# - - - - - - - - - - - - - - - - - - - - - -

function push {
  for IMAGE in ${IMAGES[*]}
  do
    echo "---------------------------------------"
    echo "PUSHING: ${HUB}/${IMAGE}"
    docker push ${HUB}/${IMAGE}
  done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function pull {
  for IMAGE in ${IMAGES[*]}
  do
    echo "---------------------------------------"
    echo "PULLING: ${HUB}/${IMAGE}"
    docker pull ${HUB}/${IMAGE}
  done
}

# - - - - - - - - - - - - - - - - - - - - - -

function up {
  # After [up] tests can be run *inside* the container, eg
  # $ docker exec web_1 bash -c "cd test/app_models && ./test_dojo.rb"
  pushd ${MY_DIR} > /dev/null
  ./cyber-dojo-up.sh --rails_env=${RAILS_ENV} --home=${HOME} --katas=${KATAS} --runner=${RUNNER}
  popd > /dev/null
}

# - - - - - - - - - - - - - - - - - - - - - -

for arg in "$@"
do
  case ${arg} in
    reset)
      doReset=true
      ;;
    clean)
      doClean=true
      ;;
    build)
      doBuild=true
      ;;
    push)
      doPush=true
      ;;
    pull)
      doPull=true
      ;;
    up)
      doUp=true
      ;;
    rails_env=*)
      RAILS_ENV="${arg#*=}"
      exit_if_bad_rails_env
      ;;
    katas=*)
      KATAS="${arg#*=}"
      exit_if_bad_katas
      ;;
    runner=*)
      RUNNER="${arg#*=}"
      exit_if_bad_runner
      ;;
    *)
      show_use
      echo "unknown command line argument ${arg}"
      exit
      ;;
  esac
done

# - - - - - - - - - - - - - - - - - - - - - -
# Do in sensible order...

if [ "$doClean" == true ]; then clean; fi
if [ "$doReset" == true ]; then reset; fi
if [ "$doBuild" == true ]; then build; fi
if [ "$doUp"    == true ]; then up   ; fi
if [ "$doPush"  == true ]; then push ; fi
if [ "$doPull"  == true ]; then pull ; fi
