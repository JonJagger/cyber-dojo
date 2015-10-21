# run as sudo

cp /home/docker/rsyncd.conf /etc
chown root:root /etc/rsyncd.conf
chmod 644 /etc/rsyncd.conf

cp /home/docker/rsyncd.secrets /etc
chown root:root /etc/rsyncd.secrets
chmod 600 /etc/rsyncd.secrets

rsync --daemon

