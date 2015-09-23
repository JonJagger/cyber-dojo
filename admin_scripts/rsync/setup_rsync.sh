#!/bin/bash

cd /var/www/cyber-dojo/admin_scripts/rsync
cp etc_rsyncd.conf     /etc/rsyncd.conf
cp etc_rsyncd.secrets  /etc/rsyncd.secrets
cd /etc/init.d
mv rsync rsync.original
sed 's/RSYNC_ENABLE=false/RSYNC_ENABLE=true/' < rsync.original > rsync
chmod +x rsync
systemctl enable rsync
