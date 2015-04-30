
# to set environment variables in calling terminal...
# . ./local_server.sh

cyberdojo_root=/var/www/cyber-dojo

export CYBER_DOJO_EXERCISES_ROOT=${cyberdojo_root}/test/cyber-dojo/exercises/
export CYBER_DOJO_LANGUAGES_ROOT=${cyberdojo_root}/test/cyber-dojo/languages/
export CYBER_DOJO_KATAS_ROOT=${cyberdojo_root}/test/cyber-dojo/katas/
export CYBER_DOJO_RUNNER_CLASS_NAME=DockerTestRunner
export CYBER_DOJO_DISK_CLASS_NAME=Disk
export CYBER_DOJO_GIT_CLASS_NAME=Git