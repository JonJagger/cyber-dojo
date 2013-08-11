#!/bin/bash
# Use to install the latest cyberdojo git repo onto cyber-dojo.com

# get latest source from https://github.com/JonJagger/cyberdojo
# if it asks for a password just hit return
git pull

# ensure pulled files have correct rights
# don't chmod or chgrp the katas folder
for folder in app config exercises languages lib public script spec test
do
  eval "chown -R www-data /var/www/cyberdojo/$folder"
  eval "chgrp -R www-data /var/www/cyberdojo/$folder"
done

eval "chown www-data /var/www/cyberdojo/*"
eval "chgrp www-data /var/www/cyberdojo/*"

# poke rails
bundle install

# restart apache
service apache2 restart
