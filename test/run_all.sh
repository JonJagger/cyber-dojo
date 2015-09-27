#!/bin/bash

../languages/refresh_cache.rb
../exercises/refresh_cache.rb
./lib/make_disk_stub_cache.rb

ramDisk=/mnt/ram_disk
sudo ../admin_scripts/make_ram_disk.sh $ramDisk
export CYBER_DOJO_TMP_ROOT=$ramDisk/tmp

# - - - - - - - - - - - - - - - - - - - - - - - -

modules=(
  app_helpers
  app_lib
  app_models
  lib
  app_controllers
#  languages
#  integration
)

echo
for module in ${modules[*]}
do
    echo
    echo "======$module======"
    cd $module
    ./run_all.sh $*
    cd ..
done
echo
echo

sudo -E -u www-data ./print_coverage_summary.rb ${modules[*]} | tee test-summary.txt
