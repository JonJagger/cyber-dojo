#!/bin/sh
cyberdojo_root=/var/www/cyber-dojo
mount_point=${cyberdojo_root}/tmp/rdisk

mkdir ${mount_point}/exercises
ln -s ${mount_point}/exercises ${cyberdojo_root}/test/cyber-dojo/exercises
cp -R ${cyberdojo_root}/exercises/* ${cyberdojo_root}/test/cyber-dojo/exercises/
chmod -R 0444 ${cyberdojo_root}/test/cyber-dojo/exercises

mkdir ${mount_point}/languages
ln -s ${mount_point}/languages ${cyberdojo_root}/test/cyber-dojo/languages
cp -R ${cyberdojo_root}/languages/* ${cyberdojo_root}/test/cyber-dojo/languages/
chmod -R 0444 ${cyberdojo_root}/test/cyber-dojo/languages

mkdir ${mount_point}/katas
ln -s ${mount_point}/katas ${cyberdojo_root}/test/cyber-dojo/katas

#export CYBER_DOJO_EXERCISES_ROOT=${cyberdojo_root}/test/cyber-dojo/exercises/
#export CYBER_DOJO_LANGUAGES_ROOT=${cyberdojo_root}/test/cyber-dojo/languages/
#export CYBER_DOJO_KATAS_ROOT=${cyberdojo_root}/test/cyber-dojo/katas/
#export CYBER_DOJO_RUNNER_CLASS_NAME=DockerTestRunner
#export CYBER_DOJO_DISK_CLASS_NAME=Disk
#export CYBER_DOJO_GIT_CLASS_NAME=Git