
# TODO: convert this to Ruby
# TODO: do command-line args processing
#       (then updates will be automatically pulled by upgrades)
# TODO: docker-compose.yml file could be downloaded to tmp/
# TODO: check with works from any dir (downloads docker-compose.yml)
# TODO: add command to backup katas-data-container to .tgz file
# TODO: create katas-DATA-CONTAINER only if RUNNER=DockerTarPipeRunner?
# TODO: pull ALL language images == fetch? all? pull=all?


#ME="./$( basename ${0} )"
ME='cyber-dojo'
#MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

#HOME=/usr/src/cyber-dojo         # home folder *inside* the server image
#GITHUB_URL=https://raw.githubusercontent.com/JonJagger/cyber-dojo/master/docker

#DOCKER_HUB_USERNAME=cyberdojofoundation

#DOCKER_COMPOSE_FILE=docker-compose.yml
#DOCKER_COMPOSE_CMD="docker-compose --file=./${DOCKER_COMPOSE_FILE}"

#RUNNER_DEFAULT=DockerTarPipeRunner
#RUNNER=${RUNNER_DEFAULT}         # see app/models/dojo.rb

#KATAS_DEFAULT=/var/www/cyber-dojo/katas
#KATAS=${KATAS_DEFAULT}           # where katas are stored on the *host*

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def show_use
  lines = [
    '',
    "Use: #{ME} COMMAND",
    "     #{ME} help",
    '',
    'COMMAND(server):',
    # TODO: backup a katas-ID data-container
    '     down                 Stops and removes server',
    '     up                   Creates and starts the server',
    '',
    'COMMAND(languages):',
    '     images               Lists pulled languages',
    '     pull=IMAGE           Pulls language IMAGE',
    '     catalog              Lists all languages',
    '     rmi=IMAGE            Removes a pulled language IMAGE',
    '     upgrade              Pulls the latest server and languages',
    ''
  ]
  lines.each { |line| puts line }
end

show_use


=begin

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# process command-line args

COUNT=0
for ARG in "$@"
do
  case ${ARG} in
    # - - - - - - - server - - - - - - - -
    down)
      doDown=true
      COUNT=$((COUNT + 1))
      ;;
    up)
      doUp=true
      COUNT=$((COUNT + 1))
      ;;
    # - - - - - - - up options - - - - - - - -
    katas=*)
      KATAS="${ARG#*=}"
      ;;
    runner=*)
      RUNNER="${ARG#*=}"
      ;;
    # - - - - - - - languages - - - - - - - -
    images)
      COUNT=$((COUNT + 1))
      ;;
    pull=*)
      COUNT=$((COUNT + 1))
      ;;
    catalog)
      COUNT=$((COUNT + 1))
      ;;
    rmi=*)
      COUNT=$((COUNT + 1))
      ;;
    upgrade)
      COUNT=$((COUNT + 1))
      ;;
    # - - - - - - - - - - - - - - -
    help)
      doHelp=true
      ;;
    # - - - - - - - something's not right - - - - - - - -
    *)
      echo "${ME}: ${ARG} ?"
      echo "See '${ME} help"
      exit
      ;;
  esac
done

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# nothing is implicit

if ((${COUNT} > 1)); then
  echo 'one command only please'
  echo "See '${ME} help'"
  exit
fi

if [ -n "${doHelp}" ]; then
  show_use;
  exit;
fi

if [ $# -eq 0 ]; then
  echo 'no command entered'
  echo "See '${ME} help'"
  exit
fi

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
  #
  # docker build \
  #     --build-arg=CYBER_DOJO_KATAS_ROOT=${HOME}/katas \
  #     --tag=${DOCKER_HUB_USERNAME}/katas \
  #     --file=./app/docker/Dockerfile.katas-data-container.empty \
  #     ${KATAS}
  #
  # rm ${KATAS}/Dockerfile
  #
  # docker run \
  #     --name ${KATAS_DATA_CONTAINER} \
  #     ${DOCKER_HUB_USERNAME}/katas \
  #     echo 'cdfKatasDC'
end

# - - - - - - - - - - - - - - - - - - - - - - - - -

def create_full_katas_data_container
  #
  # docker build \
  #     --build-arg=CYBER_DOJO_KATAS_ROOT=${HOME}/katas \
  #     --tag=${DOCKER_HUB_USERNAME}/katas \
  #     --file=./app/docker/Dockerfile.katas-data-container.copied \
  #     ${KATAS}
  #
  # rm ${KATAS}/Dockerfile
  #
  # docker run \
  #     --name ${KATAS_DATA_CONTAINER} \
  #     ${DOCKER_HUB_USERNAME}/katas \
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
  PULLED_IMAGES=$(docker images | grep ${DOCKER_HUB_USERNAME} | awk '{print $1}')
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

def pull(image)
  `docker pull #{DOCKER_HUB_USERNAME}/#{image}:latest`
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def catalog
  `./app/languages/list_all_images.rb`
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def rmi(image)
  `docker rmi #{DOCKER_HUB_USERNAME}/#{image}`
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

=end