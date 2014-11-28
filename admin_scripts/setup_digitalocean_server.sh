#!/bin/bash

# Script to build a cyber-dojo server
# from http://cloud.digitalocean.com
# base of Application: Docker 1.3.1 on 14.04
# Typically takes about 30 mins to run

cd ~
echo gem: --no-rdoc --no-ri > ~/.gemrc
apt-get update
apt-get install -y apache2 curl git build-essential zlibc zlib1g-dev zlib1g libcurl4-openssl-dev libssl-dev apache2-prefork-dev libapr1-dev libaprutil1-dev libreadline6 libreadline6-dev
apt-get install -y build-essential libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion
wget ftp://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.3.tar.gz
tar xzvf ruby-2.1.3.tar.gz
cd ruby-2.1.3
./configure --disable-install-doc
make
make install
ln -s /usr/local/bin/ruby /usr/bin/ruby
gem update --system
gem install rails --version 4.0.3
gem install passenger --pre
passenger-install-apache2-module --auto


echo #cyber-dojo >> /etc/apache2/apache2.conf
echo "<VirtualHost *:80>" >> /etc/apache2/apache2.conf
echo "	  ServerName www.yourhost.com" >> /etc/apache2/apache2.conf
echo "	  # !!! Be sure to point DocumentRoot to 'public'!" >> /etc/apache2/apache2.conf
echo "	  DocumentRoot /var/www/cyber-dojo/public " >> /etc/apache2/apache2.conf
echo "	  <Directory /var/www/cyber-dojo/public>" >> /etc/apache2/apache2.conf
echo "	     # This relaxes Apache security settings." >> /etc/apache2/apache2.conf
echo "	     AllowOverride all" >> /etc/apache2/apache2.conf
echo "	     # MultiViews must be turned off." >> /etc/apache2/apache2.conf
echo "	     Options -MultiViews" >> /etc/apache2/apache2.conf
echo "	     # Uncomment this if you're on Apache >= 2.4:" >> /etc/apache2/apache2.conf
echo "	     #Require all granted" >> /etc/apache2/apache2.conf
echo "	  </Directory>" >> /etc/apache2/apache2.conf
echo "</VirtualHost>" >> /etc/apache2/apache2.conf


echo LoadModule passenger_module /usr/local/lib/ruby/gems/2.1.0/gems/passenger-4.0.53/buildout/apache2/mod_passenger.so > /etc/apache2/mods-available/passenger.load
echo PassengerRoot /usr/local/lib/ruby/gems/2.1.0/gems/passenger-4.0.53 > /etc/apache2/mods-available/passenger.conf
echo PassengerDefaultRuby /usr/local/bin/ruby >> /etc/apache2/mods-available/passenger.conf
echo PassengerMaxPoolSize 6 >> /etc/apache2/mods-available/passenger.conf
echo PassengerPoolIdleTime 0 >> /etc/apache2/mods-available/passenger.conf
echo PassengerMaxRequests 1000 >> /etc/apache2/mods-available/passenger.conf
cd /etc/apache2/sites-available
cp 000-default.conf cyber-dojo.conf
sed 's/www.html/www\/cyber-dojo\/public/' < 000-default.conf > cyber-dojo.conf
cp default-ssl.conf cyber-dojo-ssl.conf
sed 's/www.html/www\/cyber-dojo\/public/' < default-ssl.conf > cyber-dojo-ssl.conf


cd /var/www
git clone https://github.com/JonJagger/cyber-dojo.git
cd cyber-dojo
chmod g+s katas
rm Gemfile.lock
bundle install
cd ..
chown -R www-data cyber-dojo
chgrp -R www-data cyber-dojo
gpasswd -a www-data docker


a2enmod passenger
a2ensite cyber-dojo
a2dissite 000-default
service apache2 restart

/var/www/cyber-dojo/admin_scripts/docker_pull_all.rb