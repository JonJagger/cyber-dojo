#!/bin/bash

ramDisk='/mnt/ramdisk'

umount $ramDisk
rm -rf $ramDisk
mkdir $ramDisk
mount -t tmpfs -o size=2m tmpfs $ramDisk
chmod -R 777 $ramDisk
chown -R www-data:www-data $ramDisk
