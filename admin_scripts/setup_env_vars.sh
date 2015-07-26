#!/bin/bash

# Sets up environment variables.
# See config/applications.rb's config.before_configuration 

cyberdojo_root=/var/www/cyber-dojo

export CYBER_DOJO_EXERCISES_ROOT=${cyberdojo_root}/exercises/
export CYBER_DOJO_LANGUAGES_ROOT=${cyberdojo_root}/languages/
export CYBER_DOJO_KATAS_ROOT=${cyberdojo_root}/katas/

export CYBER_DOJO_RUNNER_CLASS_NAME=HostRunner
export CYBER_DOJO_DISK_CLASS_NAME=HostDisk
export CYBER_DOJO_GIT_CLASS_NAME=HostGit
export CYBER_DOJO_ONE_SELF_CLASS_NAME=OneSelf
