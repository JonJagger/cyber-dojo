#!/bin/bash

# running this on the Turnkey Ruby-on-Rails image (14.0)
# https://www.turnkeylinux.org/updates/rails/new-turnkey-rails-version-140
# sets up cyber-dojo as the default rails server,
# installs all the necessary gems
# and also installs docker.

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

echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list.d/sources.list
apt-get update
apt-get install -y docker.io

gpasswd -a www-data docker
service docker restart