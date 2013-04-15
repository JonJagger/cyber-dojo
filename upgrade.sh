#!/bin/bash
# This script contains the commands used to convert the ruby 1.8 Rails-Turnkey image
# into a ruby 1.9 Rails-Turnkey image, as detailed in the blog entry
# http://jonjagger.blogspot.co.uk/2012/05/building-rails-3-turnkey-image.html

cd ~
apt-get purge ruby-enterprise

cd ~
wget http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz
tar xzf yaml-0.1.4.tar.gz
cd yaml-0.1.4
./configure
make
make install

cd ~
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p125.tar.gz
tar xzf ruby-1.9.3-p125.tar.gz
cd ruby-1.9.3-p125
./configure --disable-install-doc
make
make install

cd /var/www
git clone https://JonJagger@github.com/JonJagger/cyberdojo
chown -R www-data cyberdojo
chgrp -R www-data cyberdojo
cd cyberdojo
gem update --system
gem update --no-rdoc
gem install bundle --no-ri --no-rdoc
bundle install

cd /etc/apache2/sites-enabled
sed s/railsapp/cyberdojo/ <railsapp >cyberdojo
rm railsapp
cd /etc/apache2/sites-available
sed s/railsapp/cyberdojo/ <railsapp >cyberdojo
rm railsapp
cd /etc/apache2/conf
sed s/railsapp/cyberdojo/ <railsapp.conf >cyberdojo.conf
rm railsapp.conf

cd ~
apt-get update
cd /var/www/cyberdojo
gem install passenger --no-ri --no-rdoc
passenger-install-apache2-module