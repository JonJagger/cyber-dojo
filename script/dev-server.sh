#!/bin/bash

# Run's a local rails-server.
# Assumes
# o) bundle install has run
# o) docker is installed
# o) some language-images have been pulled.

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
RUNNER=${1:-DockerTarPipeRunner}

pushd ${MY_DIR} > /dev/null
HOME=${PWD}
popd > /dev/null

export CYBER_DOJO_LANGUAGES_ROOT=${HOME}/app/languages
export CYBER_DOJO_EXERCISES_ROOT=${HOME}/app/exercises
export CYBER_DOJO_SHELL_CLASS=HostShell
export CYBER_DOJO_DISK_CLASS=HostDisk
export CYBER_DOJO_LOG_CLASS=StdoutLog
export CYBER_DOJO_GIT_CLASS=HostGit

# TODO: where should katas_root point to for a local server?
#       HOME/katas saves to host disk
#       /usr/src/cyber-dojo/katas  saves to data-container
export CYBER_DOJO_KATAS_ROOT=${HOME}/tmp/katas
export CYBER_DOJO_KATAS_CLASS=HostDiskKatas

# TODO: On a local-server runner can be plain volume-mounting runner. No need for tar-pipes.
export CYBER_DOJO_RUNNER_CLASS=${RUNNER}
export CYBER_DOJO_RUNNER_SUDO=''
export CYBER_DOJO_RUNNER_TIMEOUT=10

rails s $*