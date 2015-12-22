#!/bin/bash

ramDisk=$1

umount $ramDisk
rm -rf $ramDisk
mkdir -p $ramDisk
mount -t tmpfs -o size=$2 tmpfs $ramDisk
chmod -R 777 $ramDisk
chown -R www-data:www-data $ramDisk

