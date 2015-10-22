#!/bin/bash

ramDisk=$1

umount $ramDisk
rm -rf $ramDisk
mkdir $ramDisk
mount -t tmpfs -o size=1m tmpfs $ramDisk
chmod -R 777 $ramDisk
chown -R www-data:www-data $ramDisk

# eg
# $ sudo ./make_ram_disk.sh /var/www/cyber-dojo/tmp/ram-disk
# $ export CYBER_DOJO_TMP_ROOT=/var/www/cyber-dojo/tmp/ram-disk
