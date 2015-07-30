FROM phusion/passenger-ruby22
MAINTAINER Mike Long <mike@praqma.com>

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# WORK IN PROGRESS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Need to determine how a dockerized cyber-dojo server will itself have
# access to docker to be able to process the incoming [test] events.
#
# Commands to build and run cyber-dojo server (tested from OSX using boot2docker)
#     $ docker build -t mike/cyberdojo:latest .
#     $ docker run -d -P -p 80:80 -p 443:443 mike/cyberdojo:latest
#
# From plain terminal determine the IP address to put into the browser
#     $ boot2docker ip
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

RUN echo gem: --no-rdoc --no-ri > ~/.gemrc
RUN apt-get update

RUN apt-get install -y apache2 curl git build-essential zlibc zlib1g-dev zlib1g libcurl4-openssl-dev libssl-dev apache2-prefork-dev libapr1-dev libaprutil1-dev libreadline6 libreadline6-dev
RUN apt-get install -y build-essential libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion

RUN gem update --system
RUN gem install rails --version 4.0.3
RUN gem install passenger --version 4.0.53 --pre

RUN echo #cyber-dojo >> /etc/apache2/apache2.conf
RUN echo "<VirtualHost *:80>" >> /etc/apache2/apache2.conf
RUN echo "	  ServerName www.yourhost.com" >> /etc/apache2/apache2.conf
RUN echo "	  # !!! Be sure to point DocumentRoot to 'public'!" >> /etc/apache2/apache2.conf
RUN echo "	  DocumentRoot /var/www/cyber-dojo/public " >> /etc/apache2/apache2.conf
RUN echo "	  <Directory /var/www/cyber-dojo/public>" >> /etc/apache2/apache2.conf
RUN echo "	     # This relaxes Apache security settings." >> /etc/apache2/apache2.conf
RUN echo "	     AllowOverride all" >> /etc/apache2/apache2.conf
RUN echo "	     # MultiViews must be turned off." >> /etc/apache2/apache2.conf
RUN echo "	     Options -MultiViews" >> /etc/apache2/apache2.conf
RUN echo "	     # Uncomment this if you're on Apache >= 2.4:" >> /etc/apache2/apache2.conf
RUN echo "	     #Require all granted" >> /etc/apache2/apache2.conf
RUN echo "	  </Directory>" >> /etc/apache2/apache2.conf
RUN echo "</VirtualHost>" >> /etc/apache2/apache2.conf

RUN echo LoadModule passenger_module /var/lib/gems/2.2.0/gems/passenger-4.0.53/buildout/apache2/mod_passenger.so > /etc/apache2/mods-available/passenger.load
RUN echo PassengerRoot /var/lib/gems/2.2.0/gems/passenger-4.0.53 > /etc/apache2/mods-available/passenger.conf
RUN echo PassengerDefaultRuby /usr/bin/ruby2.2 >> /etc/apache2/mods-available/passenger.conf
RUN echo PassengerMaxPoolSize 6 >> /etc/apache2/mods-available/passenger.conf
RUN echo PassengerPoolIdleTime 0 >> /etc/apache2/mods-available/passenger.conf
RUN echo PassengerMaxRequests 1000 >> /etc/apache2/mods-available/passenger.conf
RUN echo PassengerUserSwitching on >> /etc/apache2/mods-available/passenger.conf
RUN echo PassengerDefaultUser www-data >> /etc/apache2/mods-available/passenger.conf
RUN echo PassengerDefaultGroup www-data >> /etc/apache2/mods-available/passenger.conf

RUN cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/cyber-dojo.conf
RUN sed 's/www.html/www\/cyber-dojo\/public/' < /etc/apache2/sites-available/000-default.conf > /etc/apache2/sites-available/cyber-dojo.conf
RUN cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/cyber-dojo-ssl.conf
RUN sed 's/www.html/www\/cyber-dojo\/public/' < /etc/apache2/sites-available/default-ssl.conf > /etc/apache2/sites-available/cyber-dojo-ssl.conf

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Install cyber-dojo

RUN mkdir -p /var/www/
WORKDIR /var/www
RUN git clone https://JonJagger@github.com/JonJagger/cyber-dojo

RUN mkdir -p /var/www/cyber-dojo
RUN chmod g+s /var/www/cyber-dojo/katas
RUN rm /var/www/cyber-dojo/Gemfile.lock
RUN cd /var/www/cyber-dojo && bundle install
RUN cd /var/www/ && chown -R www-data cyber-dojo
RUN cd /var/www/ && chgrp -R www-data cyber-dojo

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

RUN sed -i '/Mutex file/d' /etc/apache2/apache2.conf
RUN passenger-install-apache2-module --auto

RUN a2enmod passenger
RUN a2ensite cyber-dojo
RUN a2dissite 000-default

CMD [ "/usr/sbin/apache2ctl", "-DFOREGROUND" ]
