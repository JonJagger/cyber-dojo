docker-machine scp /var/www/rsyncd.secrets $1:/home/docker/rsyncd.secrets
docker-machine ssh $1 -- sudo chown root:root /home/docker/rsyncd.secrets
docker-machine ssh $1 -- sudo chmod 400 /home/docker/rsyncd.secrets
docker-machine ssh $1 -- sudo mv /home/docker/rsyncd.secrets /etc
