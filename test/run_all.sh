#!/bin/bash

sudo -E ../languages/refresh_cache.rb
sudo -E ../exercises/refresh_cache.rb

# - - - - - - - - - - - - - - - - - - - - - - - -

ramDisk=/mnt/ram-disk
sudo ../admin_scripts/make_ram_disk.sh $ramDisk 1g

sudo chmod 777 ./test-summary.txt

# - - - - - - - - - - - - - - - - - - - - - - - -

modules=(
  app_helpers
  app_lib
  app_models
  languages
  lib
  app_controllers
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
