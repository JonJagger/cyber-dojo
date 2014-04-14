#!/bin/bash
# Use to install the latest cyberdojo git repo onto a cyber-dojo server

# get latest source from https://github.com/JonJagger/cyberdojo
# if it asks for a password just hit return
git pull
ret=$?
if [ $ret -ne 0 ]; then
  exit
fi

# ensure pulled files have correct rights
# don't chmod or chgrp the katas folder (no need and very large)
for folder in app config exercises languages lib log notes public script spec test
do
  echo "chown/chgrp www-data ${folder}"
  eval "chown -R www-data /var/www/cyberdojo/$folder"
  eval "chgrp -R www-data /var/www/cyberdojo/$folder"
done

echo "chown/chgrp www-data *"
eval "chown www-data /var/www/cyberdojo/*"
eval "chgrp www-data /var/www/cyberdojo/*"

echo "chown/chgrp www-data .*"
eval "chown www-data /var/www/cyberdojo/.*"
eval "chgrp www-data /var/www/cyberdojo/.*"

# poke rails
bundle install

# restart apache
service apache2 restart
