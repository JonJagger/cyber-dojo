#!/bin/bash

# Assumes yml files are in their respective git repo folders.
# After [up] tests can be run *inside* the container, eg
# $ docker exec os_web_1 bash -c "cd test/app_models && ./test_dojo.rb"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
IMAGES=(tmp web nginx)

# - - - - - - - - - - - - - - - - - - - - - -

function reset {
  # remove existing images
  for image in ${IMAGES[*]}
  do
    docker rmi -f cyberdojofoundation/${image} 2&> /dev/null
  done
}

# - - - - - - - - - - - - - - - - - - - - - -

function clean {
  # remove *ALL* existing containers
  docker ps -aq | xargs docker rm -f
  # remove untagged images
  docker images -q --filter "dangling=true" | xargs docker rmi
}

# - - - - - - - - - - - - - - - - - - - - - -

function build {
  exit_if_no_root
  # build images via Dockerfiles
  pushd ${DIR} > /dev/null
    for image in ${IMAGES[*]}
    do
      cd ../../images/${image}
      ./build_docker_image.sh ${ROOT}
      if [ $? -ne 0 ]; then
        echo "BUILDING cyberdojofoundation/${image} FAILED"
        exit
      fi
    done
  popd > /dev/null
}

# - - - - - - - - - - - - - - - - - - - - - -

function push {
  for image in ${IMAGES[*]}
  do
    hub_image=cyberdojofoundation/${image}
    echo "---------------------------------------"
    echo "PUSHING: ${hub_image}"
    echo "---------------------------------------"
    docker push ${hub_image}
  done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function pull {
  for image in ${IMAGES[*]}
  do
    hub_image=cyberdojofoundation/${image}
    echo "---------------------------------------"
    echo "PULLING: ${hub_image}"
    echo "---------------------------------------"
    docker pull ${hub_image}
  done
}

# - - - - - - - - - - - - - - - - - - - - - -

function up {
  exit_if_no_root
  exit_if_bad_up
  pushd ${DIR} > /dev/null
  export CYBER_DOJO_ROOT=${ROOT}
  export CYBER_DOJO_UP=${UP}
  docker-compose \
    --file ../docker-compose.yml \
    --file docker-compose.osx.yml \
    up &
  popd > /dev/null
}

# - - - - - - - - - - - - - - - - - - - - - -

function show_use {
  echo "cdf.sh --reset"
  echo "cdf.sh --clean"
  echo "cdf.sh --build --root=ROOT "
  echo "cdf.sh --push"
  echo "cdf.sh --pull"
  echo "cdf.sh --up=development --root=ROOT"
  echo "cdf.sh --up=production  --root=ROOT"
  echo "...or combined"
  echo "cdf.sh --clean --build --root=ROOT --up=development"
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

if [ "$doReset" == true ]; then reset; fi
if [ "$doClean" == true ]; then clean; fi
if [ "$doBuild" == true ]; then build; fi
if [ "$doUp"    == true ]; then up   ; fi
if [ "$doPush"  == true ]; then push ; fi
if [ "$doPull"  == true ]; then pull ; fi
