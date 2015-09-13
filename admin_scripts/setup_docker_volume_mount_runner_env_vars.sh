#!/bin/bash

# Sets up environment variables.
# See config/applications.rb's config.before_configuration 

cyber_dojo_root=/var/www/cyber-dojo

export CYBER_DOJO_EXERCISES_ROOT=${cyber_dojo_root}/exercises/
export CYBER_DOJO_LANGUAGES_ROOT=${cyber_dojo_root}/languages/
export CYBER_DOJO_KATAS_ROOT=${cyber_dojo_root}/katas/

export CYBER_DOJO_RUNNER_CLASS=DockerVolumeMountRunner
export CYBER_DOJO_DISK_CLASS=HostDisk
export CYBER_DOJO_GIT_CLASS=HostGit
export CYBER_DOJO_ONE_SELF_CLASS=OneSelf
