#!/bin/bash

# running this on the Turnkey Rails image (http://www.turnkeylinux.org/rails)
# sets up cyber-dojo as the default rails server,
# installs all the necessary gems
# and also installs docker.

echo this will take a while...
cd /var/www
rm index.html
rm -rf railsapp
cd /etc/apache2/sites-available
sed s/railsapp/cyber-dojo/ <railsapp >cyber-dojo
rm railsapp
cd /etc/apache2/sites-enabled
ln -s ../sites-available/cyber-dojo cyber-dojo
rm railsapp
cd /etc/apache2/conf
sed s/railsapp/cyber-dojo/ <railsapp.conf >cyber-dojo.conf
rm railsapp.conf
cd /var/www/cyber-dojo/admin_scripts
./pull.sh
echo "deb http://get.docker.io/ubuntu docker main" > /etc/apt/sources.list.d/docker.list
wget -qO- https://get.docker.io/gpg | apt-key add -
apt-get update
apt-get -y install lxc-docker
groupadd docker
gpasswd -a www-data docker
