#!/bin/bash

ramDisk='/mnt/ramdisk'

umount $ramDisk
rm -rf $ramDisk
mkdir $ramDisk
mount -t tmpfs -o size=2m tmpfs $ramDisk
