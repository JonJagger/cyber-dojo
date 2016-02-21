#!/bin/bash

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
RUNNER=${1:-DockerKatasDataContainerRunner}

CWD=$(pwd)
cd "${MY_DIR}" > /dev/null
cd ..
HOME=$(pwd)

export CYBER_DOJO_LANGUAGES_ROOT=${HOME}/app/languages
export CYBER_DOJO_EXERCISES_ROOT=${HOME}/app/exercises
export CYBER_DOJO_CACHES_ROOT=${HOME}/app/caches
export CYBER_DOJO_SHELL_CLASS=HostShell
export CYBER_DOJO_DISK_CLASS=HostDisk
export CYBER_DOJO_LOG_CLASS=HostLog
export CYBER_DOJO_GIT_CLASS=HostGit

# TODO: where should katas_root point to for a local server?
export CYBER_DOJO_KATAS_ROOT=${HOME}/katas
export CYBER_DOJO_KATAS_CLASS=HostDiskKatas

# TODO: runner can be plain volume-mounting runner. No need for tar-pipes.
export CYBER_DOJO_RUNNER_CLASS=${RUNNER}
export CYBER_DOJO_RUNNER_SUDO=''
export CYBER_DOJO_RUNNER_TIMEOUT=10

cd "${CWD}" > /dev/null

rm ${CYBER_DOJO_CACHES_ROOT}/*.json

rails s $*