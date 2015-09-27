#!/bin/bash

ramDisk=$1

umount $ramDisk
rm -rf $ramDisk
mkdir $ramDisk
mount -t tmpfs -o size=500k tmpfs $ramDisk
chmod -R 777 $ramDisk
chown -R www-data:www-data $ramDisk
