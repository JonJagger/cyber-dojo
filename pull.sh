#!/bin/bash
# This script contains the commands used to install the latest
# cyberdojo git repo onto cyber-dojo.com

git pull
chown -R www-data /var/www/cyberdojo
chgrp -R www-data /var/www/cyberdojo
bundle install
service apache2 restart
