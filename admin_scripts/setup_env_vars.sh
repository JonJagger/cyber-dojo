#!/bin/bash

rootDir=/var/www/cyber-dojo
export CYBER_DOJO_LANGUAGES_ROOT=${rootDir}/languages
export CYBER_DOJO_EXERCISES_ROOT=${rootDir}/exercises
export CYBER_DOJO_KATAS_ROOT=${rootDir}/katas
export CYBER_DOJO_CACHES_ROOT=${rootDir}/caches

export CYBER_DOJO_RUNNER_CLASS=DockerRunner
export CYBER_DOJO_DISK_CLASS=HostDisk
export CYBER_DOJO_GIT_CLASS=HostGit
export CYBER_DOJO_ONE_SELF_CLASS=CurlOneSelf
