#!/bin/bash

chmod 777 ./test-summary.txt

modules=(
  app_helpers
  app_lib
  app_models
  #languages
  lib
  app_controllers
)

for module in ${modules[*]}
do
    echo
    echo "======$module======"
    cd $module
    ./run.sh $*
    cd ..
done

./print_coverage_summary.rb ${modules[*]} | tee test-summary.txt
