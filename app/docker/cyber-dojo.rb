#!/bin/ruby

# TODO: convert this to Ruby
#       assume command-line args already processed by sh file













ME="./$( basename ${0} )"
MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

HOME=/usr/src/cyber-dojo         # home folder *inside* the server image
GITHUB_URL=https://raw.githubusercontent.com/JonJagger/cyber-dojo/master/docker

DOCKER_COMPOSE_FILE=docker-compose.yml
DOCKER_COMPOSE_CMD="docker-compose --file=./${DOCKER_COMPOSE_FILE}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

RUNNER_DEFAULT=DockerTarPipeRunner
RUNNER=${RUNNER_DEFAULT}         # see app/models/dojo.rb

KATAS_DEFAULT=/var/www/cyber-dojo/katas
KATAS=${KATAS_DEFAULT}           # where katas are stored on the *host*


# TODO: check with works from any dir (downloads docker-compose.yml)
# TODO: add command to backup katas-data-container to .tgz file
# TODO: create katas-DATA-CONTAINER only if RUNNER=DockerTarPipeRunner?
# TODO: pull ALL language images == fetch? all? pull=all?



#========================================================================================
# server
#========================================================================================

def down
  #nothing to do
  #${DOCKER_COMPOSE_CMD} down
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def up
  one_time_create_katas_data_container
  pull_common_languages_if_none
end

# - - - - - - - - - - - - - - - - - - - - - - - - -

KATAS_DATA_CONTAINER=cdf-katas-DATA-CONTAINER

def create_empty_katas_data_container
  # TODO: this can be named-Dockerfile in app/docker folder (inside image)
  #
  # echo 'FROM cyberdojofoundation/user-base'                  > ${MY_DIR}./Dockerfile
  # echo 'ARG CYBER_DOJO_KATAS_ROOT'                          >> ${MY_DIR}/Dockerfile
  # echo 'USER root'                                          >> ${MY_DIR}/Dockerfile
  # echo 'RUN  mkdir -p ${CYBER_DOJO_KATAS_ROOT}'             >> ${MY_DIR}/Dockerfile
  # echo 'RUN  chown -R cyber-dojo ${CYBER_DOJO_KATAS_ROOT}'  >> ${MY_DIR}/Dockerfile
  # echo 'VOLUME [ "${CYBER_DOJO_KATAS_ROOT}" ]'              >> ${MY_DIR}/Dockerfile
  # echo 'CMD [ "katas-data-container" ]'                     >> ${MY_DIR}/Dockerfile
  #
  # docker build \
  #     --build-arg=CYBER_DOJO_KATAS_ROOT=${HOME}/katas \
  #     --tag=${HUB_USER}/katas \
  #     --file=${KATAS}/Dockerfile \
  #     ${KATAS}
  #
  # rm ${KATAS}/Dockerfile
  #
  # docker run \
  #     --name ${KATAS_DATA_CONTAINER} \
  #     ${HUB_USER}/katas \
  #     echo 'cdfKatasDC'
end

# - - - - - - - - - - - - - - - - - - - - - - - - -

def create_full_katas_data_container
  # TODO: this can be named-Dockerfile in app/docker folder (inside image)
  #
  # echo 'FROM cyberdojofoundation/user-base'                  > ${KATAS}/Dockerfile
  # echo 'MAINTAINER Jon Jagger <jon@jaggersoft.com>'         >> ${KATAS}/Dockerfile
  # echo 'ARG CYBER_DOJO_KATAS_ROOT'                          >> ${KATAS}/Dockerfile
  # echo 'USER root'                                          >> ${KATAS}/Dockerfile
  # echo 'RUN  mkdir -p ${CYBER_DOJO_KATAS_ROOT}'             >> ${KATAS}/Dockerfile
  # echo 'COPY . ${CYBER_DOJO_KATAS_ROOT}'                    >> ${KATAS}/Dockerfile
  # echo 'RUN  chown -R cyber-dojo ${CYBER_DOJO_KATAS_ROOT}'  >> ${KATAS}/Dockerfile
  # echo 'VOLUME [ "${CYBER_DOJO_KATAS_ROOT}" ]'              >> ${KATAS}/Dockerfile
  # echo 'CMD [ "katas-data-container" ]'                     >> ${KATAS}/Dockerfile
  #
  # docker build \
  #     --build-arg=CYBER_DOJO_KATAS_ROOT=${HOME}/katas \
  #     --tag=${HUB_USER}/katas \
  #     --file=${KATAS}/Dockerfile \
  #     ${KATAS}
  #
  # rm ${KATAS}/Dockerfile
  #
  # docker run \
  #     --name ${KATAS_DATA_CONTAINER} \
  #     ${HUB_USER}/katas \
  #     echo 'cdfKatasDC'
end

# - - - - - - - - - - - - - - - - - - - - - - - - -

def one_time_create_katas_data_container
  if [ ! -d "${KATAS}" ]; then
    if [ "${KATAS}" != "${KATAS_DEFAULT}" ]; then
      echo "${ME}: katas=${KATAS} ? ${KATAS} directory does not exist"
      echo "See ${ME} help"
      exit
    else # no dir at default location. Assume new server
       create_empty_katas_data_container
    fi
  else # katas dir exists, copy into data-container
     create_full_katas_data_container
  fi
end

#========================================================================================
# languages
#========================================================================================

def pulled_language_images
  ALL_LANGUAGE_IMAGES=$(echo "${CATALOG}" | awk '{print $NF}' | sort)
  PULLED_IMAGES=$(docker images | grep ${HUB_USER} | awk '{print $1}')
  SPLIT=$(echo "${PULLED_IMAGES}" | sed 's/\// /g')
  PULLED_IMAGES=$(echo "${SPLIT}" | awk '{print $NF}' | sort)

  TMP_FILE_1=/tmp/cyber-dojo.comm1.txt
  TMP_FILE_2=/tmp/cyber-dojo.comm2.txt
  echo "${ALL_LANGUAGE_IMAGES}" > ${TMP_FILE_1}
  echo       "${PULLED_IMAGES}" > ${TMP_FILE_2}
  comm -12 ${TMP_FILE_1} ${TMP_FILE_2}

  # These two lines cause docker containers to stop and I have no idea why?!
  #rm ${TMP_FILE_1}
  #rm ${TMP_FILE_2}
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def images
  # FIXME: this gives the same as catalog when there are no languages pulled
  CATALOG=$(catalog)
  PULLED=$(pulled_language_images)
  echo "${CATALOG}" | grep 'LANGUAGE'
  echo "${CATALOG}" | grep "${PULLED}"
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def pull
  docker pull ${HUB_USER}/${IMAGE}:latest
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def catalog
  # will pull web image if necessary
  docker run --rm ${HUB_USER}/web sh -c "./app/languages/list_all_images.rb"
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def rmi
  docker rmi ${HUB_USER}/${IMAGE}
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def pull_common_languages_if_none
  CATALOG=$(catalog)
  PULLED=$(pulled_language_images)
  if [ -z "${PULLED}" ]; then
    echo 'No language images pulled'
    echo 'Pulling a small starting collection of common language images'
    IMAGE=gcc_assert
    pull
    #IMAGE=ruby_mini_test
    #pull
  fi
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def upgrade
  echo "downloading latest ${DOCKER_COMPOSE_FILE} file"
  download_latest_docker_compose_yml
  echo 'upgrading cyber-dojo server images'
  CWD=$(pwd)
  cd "${MY_DIR}" > /dev/null
  SERVICES=`${DOCKER_COMPOSE_CMD} config --services 2> /dev/null`
  cd "${CWD}" > /dev/null
  echo "${SERVICES}" | while read IMAGE ; do
    pull
  done

  echo 'upgrading cyber-dojo pulled language images'
  CATALOG=$(catalog)
  PULLED=$(pulled_language_images)
  echo "${PULLED}" | while read IMAGE ; do
    pull
  done
end

def download_latest_docker_compose_yml
  CWD=$(pwd)
  cd "${MY_DIR}" > /dev/null
  curl -O ${GITHUB_URL}/${DOCKER_COMPOSE_FILE}
  cd "${CWD}" > /dev/null
end

#========================================================================================
# you must have the docker-compose.yml file
#========================================================================================

if [ ! -e ${MY_DIR}/${DOCKER_COMPOSE_FILE} ]; then
  download_latest_docker_compose_yml
fi

#========================================================================================
# katas data-container is decoupled from cyber-dojo script
#========================================================================================

docker ps -a | grep ${katas_DATA_CONTAINER} > /dev/null
if [ $? != 0 ]; then
  one_time_create_katas_data_container
fi

#========================================================================================
# docker-compose.yml relies on these env-vars
#========================================================================================

export CYBER_DOJO_HOME=${HOME}
export CYBER_DOJO_KATAS_ROOT=${HOME}/katas
export CYBER_DOJO_KATAS_CLASS=HostDiskKatas
export CYBER_DOJO_RUNNER_CLASS=${RUNNER}
export CYBER_DOJO_RUNNER_SUDO='sudo -u docker-runner sudo'
export CYBER_DOJO_RUNNER_TIMEOUT=10

#========================================================================================
# do something!
#========================================================================================

if [ -n "${doDown}"    ]; then down   ; exit; fi
if [ -n "${doUp}"      ]; then up     ; exit; fi

if [ -n "${doImages}"  ]; then images ; exit; fi
if [ -n "${doPull}"    ]; then pull   ; exit; fi
if [ -n "${doCatalog}" ]; then catalog; exit; fi
if [ -n "${doRmi}"     ]; then rmi    ; exit; fi
if [ -n "${doUpgrade}" ]; then upgrade; exit; fi
