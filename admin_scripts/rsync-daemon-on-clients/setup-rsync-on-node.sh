
docker-machine start $1

# setup rsync

# The default mirror for tce-load (like apt-get/yum) was down so I had to change it
docker-machine ssh $1 -- sudo cp /opt/tcemirror /opt/tcemirror.original
docker-machine ssh $1 -- "sudo echo 'http://distro.ibiblio.org/tinycorelinux' > /opt/tcemirror"
# Now I can install rsync
docker-machine ssh $1 -- tce-load -wi rsync
# Copy rsyncd.conf to node
docker-machine scp /var/www/rsyncd.conf    $1:/home/docker/rsyncd.conf
docker-machine ssh $1 -- sudo chown root:root /home/docker/rsyncd.conf
docker-machine ssh $1 -- sudo chmod 400 /home/docker/rsyncd.conf
docker-machine ssh $1 -- sudo mv /home/docker/rsyncd.conf /etc
# Copy rsyncd.secrets to node
# Create this file on the server using setup-rsync-password.sh
docker-machine scp /var/www/rsyncd.secrets $1:/home/docker/rsyncd.secrets
docker-machine ssh $1 -- sudo chown root:root /home/docker/rsyncd.secrets
docker-machine ssh $1 -- sudo chmod 400 /home/docker/rsyncd.secrets
docker-machine ssh $1 -- sudo mv /home/docker/rsyncd.secrets /etc
# Set the rsync daemon running
docker-machine ssh $1 -- sudo rsync --daemon

# rsyncd.conf downloads all files as owned by www-data which is
# necessary because the docker-run command uses --user=www-data
docker-machine ssh $1 -- sudo addgroup -g 33 www-data
docker-machine ssh $1 -- sudo adduser -D -H -G www-data -s /bin/sh -u 33 www-data
