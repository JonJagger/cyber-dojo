#!/bin/bash


. /var/www/cyber-dojo/admin_scripts/make_mac_os_ram_disk.sh
. /var/www/cyber-dojo/admin_scripts/make_mac_os_ram_dirs.sh
. /var/www/cyber-dojo/admin_scripts/make_env_vars.sh
export CYBER_DOJO_RUNNER_CLASS_NAME=HostTestRunner
rails s