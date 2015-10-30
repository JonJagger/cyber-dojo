#!/bin/bash

# running this on the Turnkey Ruby-on-Rails image (14.0)
# https://www.turnkeylinux.org/updates/rails/new-turnkey-rails-version-140
# sets up cyber-dojo as the default rails server,
# and also installs docker and docker-machine

# - - - - - - - - - - - - - - - - - - - - - - - - -
# setup the apache server

cd /etc/apache2/sites-available
sed 's/www.html/www\/cyber-dojo\/public/' < 000-default.conf > cyber-dojo.conf
sed 's/www.html/www\/cyber-dojo\/public/' < default-ssl.conf > cyber-dojo-ssl.conf

cd /etc/apache2/sites-enabled
ln -s ../sites-available/cyber-dojo.conf cyber-dojo.conf

chown    www-data:www-data /var
chown    www-data:www-data /var/www
chown -R www-data:www-data /var/www/cyber-dojo

cd /var/www/cyber-dojo
chmod g+s katas

a2ensite cyber-dojo
a2dissite railsapp
service apache2 reload

# - - - - - - - - - - - - - - - - - - - - - - - - -
# setup docker and docker-machine

apt-get purge lxc-docker*
apt-get purge docker.io*
# not using pgp.mit.edu because its sometimes been flaky
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list
apt-get install -y apt-transport-https
apt-get update
apt-cache policy docker-engine

apt-get install -y docker-engine
curl -L https://github.com/docker/machine/releases/download/v0.4.0/docker-machine_linux-amd64 > /usr/local/bin/docker-machine
chmod +x /usr/local/bin/docker-machine

gpasswd -a www-data docker
service docker restart


