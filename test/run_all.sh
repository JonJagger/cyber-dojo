#!/bin/bash

rootDir=/var/www/cyber-dojo
export CYBER_DOJO_LANGUAGES_ROOT=${rootDir}/languages
export CYBER_DOJO_EXERCISES_ROOT=${rootDir}/exercises
export CYBER_DOJO_KATAS_ROOT=${rootDir}/katas
export CYBER_DOJO_CACHES_ROOT=${rootDir}/caches

sudo -E ../languages/refresh_cache.rb
sudo -E ../exercises/refresh_cache.rb
sudo -E ./lib/make_disk_stub_cache.rb

unset CYBER_DOJO_EXERCISES_ROOT
unset CYBER_DOJO_LANGUAGES_ROOT
unset CYBER_DOJO_KATAS_ROOT
unset CYBER_DOJO_CACHES_ROOT

# - - - - - - - - - - - - - - - - - - - - - - - -

ramDisk=/mnt/ram_disk
sudo ../admin_scripts/make_ram_disk.sh $ramDisk 1m
export CYBER_DOJO_TMP_ROOT=$ramDisk/tmp

mkdir $ramDisk/caches
export CYBER_DOJO_CACHES_ROOT=$ramDisk/caches
cp ../caches/* $ramDisk/caches

sudo chmod 777 ./test-summary.txt

# - - - - - - - - - - - - - - - - - - - - - - - -

modules=(
  app_helpers
  app_lib
  app_models
  lib
  app_controllers
  languages
#  integration
)

for module in ${modules[*]}
do
    echo
    echo "======$module======"
    cd $module
    ./run_all.sh $*
    cd ..
done

sudo -E -u www-data ./print_coverage_summary.rb ${modules[*]} | tee test-summary.txt

unset CYBER_DOJO_TMP_ROOT
unset CYBER_DOJO_CACHES_ROOT

