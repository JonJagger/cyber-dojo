#!/bin/bash

HOME=/usr/app/cyber-dojo

# defaults
RAILS_ENV_DEFAULT=production
RUNNER_DEFAULT=DockerTmpRunner

KATAS=/usr/app/cyber-dojo/katas
RAILS_ENV=${RAILS_ENV_DEFAULT}
RUNNER=${RUNNER_DEFAULT}

# - - - - - - - - - - - - - - - - - - - - - -

USE="USE: $(basename $0)"

function show_use {
  echo "#"
  echo "# ${USE} ${ME} [help] DEFAULTS"
  echo "#"
  echo "# DEFAULTS"
  echo "# katas=${KATAS}"
  echo "# rails_env=${RAILS_ENV_DEFAULT}"
  echo "# runner=${RUNNER_DEFAULT}"
  echo "#"
  echo "# OPTIONS"
  echo "# rails_env=development"
  echo "# runner=DockerKatasRunner"
  echo ""
}

function exit_if_bad_rails_env {
  if [ "${RAILS_ENV}" != 'development' ] && [ "${RAILS_ENV}" != 'production' ]; then
    echo "# ??? rails_env=${RAILS_ENV}"
    echo "# ${USE} rails_env=development"
    echo "# ${USE} ${ME} rails_env=production"
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
    echo "# USE: ${ME} runner=development"
    echo "# USE: ${ME} runner=production"
    show_use
    exit
  fi
}

# - - - - - - - - - - - - - - - - - - - - - -

for arg in "$@"
do
  case ${arg} in
    help)
      show_use
      exit
      ;;
    home=*)
      HOME="${arg#*=}"
      ;;
    katas=*)
      KATAS="${arg#*=}"
      exit_if_bad_katas
      ;;
    runner=*)
      RUNNER="${arg#*=}"
      exit_if_bad_runner
      ;;
    rails_env=*)
      RAILS_ENV="${arg#*=}"
      exit_if_bad_rails_env
      ;;
    *)
      echo "# <${arg}> ?"
      show_use
      exit
      ;;
  esac
done

# - - - - - - - - - - - - - - - - - - - - - -

export CYBER_DOJO_RAILS_ENV=${RAILS_ENV}

export CYBER_DOJO_LANGUAGES_ROOT=${HOME}/languages
export CYBER_DOJO_EXERCISES_ROOT=${HOME}/exercises
export CYBER_DOJO_CACHES_ROOT=${HOME}/caches
export CYBER_DOJO_KATAS_ROOT=${KATAS}

export CYBER_DOJO_RUNNER_CLASS=${RUNNER}
export CYBER_DOJO_KATAS_CLASS=HostDiskKatas
export CYBER_DOJO_SHELL_CLASS=HostShell
export CYBER_DOJO_DISK_CLASS=HostDisk
export CYBER_DOJO_LOG_CLASS=HostLog
export CYBER_DOJO_GIT_CLASS=HostGit

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd ${DIR} > /dev/null

docker-compose \
  --file=./docker-compose.yml \
  up &

popd > /dev/null
