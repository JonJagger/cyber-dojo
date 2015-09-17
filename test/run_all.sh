#!/bin/bash

../languages/refresh_cache.rb
../exercises/refresh_cache.rb
./lib/make_disk_stub_cache.rb

# - - - - - - - - - - - - - - - - - - - - - - - -

modules=( 
  app_helpers 
  app_lib 
  app_models 
  app_controllers 
  lib
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
