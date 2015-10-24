#!/bin/bash

ramDisk=/var/www/cyber-dojo/tmp/ram-disk

umount $ramDisk
rm -rf $ramDisk
mkdir $ramDisk
mount -t tmpfs -o size=1m tmpfs $ramDisk
chmod -R 777 $ramDisk
chown -R www-data:www-data $ramDisk

. export CYBER_DOJO_TMP_ROOT=$ramDisk
