#!/bin/bash

# NB: at the moment this ram-disk is coupled to running the tests
#     inside a OSX VirtualBox Ubuntu VM which fuse-mounts the /var/www/cyber-dojo/ src
#     When the web app is run from inside a docker, the tests will be too and
#     the ram-disk will be dropped.

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
    ./run.sh $*
    cd ..
done

sudo -E -u www-data ./print_coverage_summary.rb ${modules[*]} | tee test-summary.txt
