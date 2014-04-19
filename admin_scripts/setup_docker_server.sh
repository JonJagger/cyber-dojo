#!/bin/bash

# running this on the Turnkey Rails image (http://www.turnkeylinux.org/rails)
# installs cyberdojo from its git repo and also installs docker.

cd /var/www
rm index.html
rm -rf railsapp
cd /etc/apache2/sites-available
sed s/railsapp/cyberdojo/ <railsapp >cyberdojo
rm railsapp
cd /etc/apache2/sites-enabled
ln -s ../sites-available/cyberdojo cyberdojo
rm railsapp
cd /etc/apache2/conf
sed s/railsapp/cyberdojo/ <railsapp.conf >cyberdojo.conf
rm railsapp.conf
cd /var/www
git clone https://JonJagger@github.com/JonJagger/cyberdojo
./pull.sh
service apache2 restart
echo "deb http://get.docker.io/ubuntu docker main" > /etc/apt/sources.list.d/docker.list
wget -qO- https://get.docker.io/gpg | apt-key add -
apt-get update
apt-get -y install lxc-docker
groupadd docker
gpasswd -a www-data docker
