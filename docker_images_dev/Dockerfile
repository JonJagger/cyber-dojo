FROM phusion/passenger-ruby22
MAINTAINER Mike Long <mike@praqma.com>

# Instructions for using this Dockerfile to create a cyber-dojo
# server inside a docker container (eg for development)
#
# These files on the host
# -----------------------
# $ sudo mkdir -p /var/www/cyber-dojo/katas/
# $ sudo chmod g+s /var/www/cyber-dojo/katas/
# $ sudo chown -R 33:33 /var/www/cyber-dojo/katas/
#
# Pull the language images you want
# ---------------------------------
# $ docker pull cyberdojofoundation/gcc_assert
# $ docker pull ...
#
# Build the image
# ---------------
# $ docker build -t cyberdojofoundation/cyber-dojo:1.0 .
#
# Run the image
# -------------
# This needs a data-container for katas/
# See katas_docker_data_container folder.
#
# $ docker run -d \
#              -v /var/run/docker.sock:/var/run/docker.sock \
#              -v /usr/local/bin/docker:/bin/docker \
#              --volumes-from cyber-dojo-katas-data-container \
#              --name=cyber-dojo \
#              -p 80:80 -p 443:443 cyberdojofoundation/cyber-dojo:1.0
#
# Refresh the cache in the container
# ----------------------------------
# $ docker exec -ti cyber-dojo bash
# $ ./cyber-dojo/admin_scripts/refresh_all_caches.sh
# $ exit
#
# Find it's IP address
# --------------------
# $ docker-machine ip default


RUN apt-get update && apt-get install --no-install-recommends -y \
        apache2 curl git build-essential zlibc zlib1g-dev \
        zlib1g libcurl4-openssl-dev libssl-dev apache2-prefork-dev \
        libapr1-dev libaprutil1-dev libreadline6 libreadline6-dev \
        build-essential libyaml-dev libsqlite3-0 libsqlite3-dev \
        sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev \
        automake libtool bison subversion uuid-runtime

RUN echo gem: --no-rdoc --no-ri > ~/.gemrc
RUN gem update --system
RUN gem install rails --version 4.0.3
RUN gem install passenger --version 4.0.53 --pre

COPY /cyber-dojo.apache2.conf /cyber-dojo.apache2.conf
RUN cat cyber-dojo.apache2.conf >> /etc/apache2/apache2.conf

RUN echo LoadModule passenger_module /var/lib/gems/2.2.0/gems/passenger-4.0.53/buildout/apache2/mod_passenger.so > /etc/apache2/mods-available/passenger.load
COPY /cyber-dojo.passenger.conf /etc/apache2/mods-available/passenger.conf
RUN cat /etc/apache2/mods-available/passenger.conf

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

RUN gpasswd -a www-data users
RUN usermod -s /bin/bash www-data

ENV CYBER_DOJO_RUNNER_CLASS DockerDataContainerRunner
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND" ]
