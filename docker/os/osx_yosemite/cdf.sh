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
  # this needs access to the Dockerfiles
  pushd ${DIR} > /dev/null
    for image in ${IMAGES[*]}
    do
      cd ../../images/${image}
      ./build_docker_image.sh ${CYBER_DOJO_ROOT}
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
  pushd ${DIR} > /dev/null
  docker-compose \
    --file ../docker-compose.yml \
    --file docker-compose.osx.yml \
    up &
  popd > /dev/null
}

# - - - - - - - - - - - - - - - - - - - - - -

if [ -z "${CYBER_DOJO_ROOT}" ]; then
  echo "cdf: CYBER_DOJO_ROOT environment variable must be set"
  exit
fi

# - - - - - - - - - - - - - - - - - - - - - -

if [ -z $1 ]; then
  echo
  echo "USE: cdf [reset | clean | build | up | push | pull]"
  echo
  exit
fi

# - - - - - - - - - - - - - - - - - - - - - -

for arg in "$@"
do
    case "$arg" in
        reset)
          doReset=true
          ;;
        clean)
          doClean=true
          ;;
        build)
          doBuild=true
          ;;
        up)
          doUp=true
          ;;
        push)
          doPush=true
          ;;
        pull)
          doPull=true
          ;;
        *)
          echo "unknown command line argument ${arg}"
          exit
          ;;
    esac
done

# - - - - - - - - - - - - - - - - - - - - - -

if [ "$doReset" == true ]; then reset; fi
if [ "$doClean" == true ]; then clean; fi
if [ "$doBuild" == true ]; then build; fi
if [ "$doUp"    == true ]; then up   ; fi
if [ "$doPush"  == true ]; then push ; fi
if [ "$doPull"  == true ]; then pull ; fi
