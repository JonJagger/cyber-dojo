# run as sudo

cp ~/rsyncd.conf /etc
chown root:root /etc/rsyncd.conf
chmod 644 /etc/rsyncd.conf

cp ~/rsyncd.secrets /etc
chown root:root /etc/rsyncd.secrets
chmod 600 /etc/rsyncd.secrets

sed -i 's/RSYNC_ENABLE=false/RSYNC_ENABLE=true/' /etc/init.d/rsync

rsync --daemon

