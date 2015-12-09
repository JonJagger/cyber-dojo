#!/bin/bash

sudo -E ../languages/refresh_cache.rb
sudo -E ../exercises/refresh_cache.rb

# - - - - - - - - - - - - - - - - - - - - - - - -

#ramDisk=/mnt/ram_disk
#sudo ../admin_scripts/make_ram_disk.sh $ramDisk 4m
#export CYBER_DOJO_TMP_ROOT=$ramDisk/tmp

#notRamDisk=/tmp/cyber-dojo
#sudo rm -rf $notRamDisk
#mkdir -p $notRamDisk
#sudo chmod -R 777 $notRamDisk
#sudo chown -R www-data:www-data $notRamDisk
#export CYBER_DOJO_TMP_ROOT=$notRamDisk

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
