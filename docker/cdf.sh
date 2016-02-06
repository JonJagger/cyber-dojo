#!/bin/bash

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
IMAGES=(exercises languages nginx test tmp web)
HUB=cyberdojofoundation

# - - - - - - - - - - - - - - - - - - - - - -

function clean {
  # remove containers (but not katas)
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
  # Assumes Dockerfiles are in their github cyber-dojo repo folders.
  exit_if_no_root
  # build images via Dockerfiles
  pushd ${MY_DIR} > /dev/null
  ALL_IMAGES=("${IMAGES[*]}" katas)
  for IMAGE in ${ALL_IMAGES[*]}
  do
    echo ${IMAGE}
    ./${IMAGE}/build-docker-image.sh ${ROOT}
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
  # Assumes yml files are in their github cyber-dojo repo folders.
  # After [up] tests can be run *inside* the container, eg
  # $ docker exec os_web_1 bash -c "cd test/app_models && ./test_dojo.rb"
  exit_if_no_root
  exit_if_bad_up
  pushd ${MY_DIR} > /dev/null
  export CYBER_DOJO_ROOT=${ROOT}
  export CYBER_DOJO_UP=${UP}
  docker-compose \
    --file=./docker-compose.yml \
    up &
  popd > /dev/null
}

# - - - - - - - - - - - - - - - - - - - - - -

function show_use {
  echo "./cdf.sh --clean"
  echo "./cdf.sh --reset"
  echo "./cdf.sh --build --root=ROOT "
  echo "./cdf.sh --push"
  echo "./cdf.sh --pull"
  echo "./cdf.sh --up=development --root=ROOT"
  echo "./cdf.sh --up=production  --root=ROOT"
  echo "...or combined"
  echo "./cdf.sh --clean --build --root=ROOT --up=development"
  echo
}

# - - - - - - - - - - - - - - - - - - - - - -

function exit_if_no_root {
  if [ -z "${ROOT}" ]; then
    show_use
    echo "--root=ROOT must be set"
    exit
  fi
}

# - - - - - - - - - - - - - - - - - - - - - -

function exit_if_bad_up {
  if [ "${UP}" != "development" ] && [ "${UP}" != "production" ]; then
    show_use
    echo "--up=development OR --up=production"
    exit
  fi
}

# - - - - - - - - - - - - - - - - - - - - - -

if [  $# -eq 0 ]; then
  show_use
  exit
fi

for arg in "$@"
do
  case ${arg} in
    --root=*)
      ROOT="${arg#*=}"
      ;;
    --reset)
      doReset=true
      ;;
    --clean)
      doClean=true
      ;;
    --build)
      doBuild=true
      ;;
    --up=*)
      UP="${arg#*=}"
      doUp=true
      ;;
    --push)
      doPush=true
      ;;
    --pull)
      doPull=true
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
