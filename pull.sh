#!/bin/bash

git pull
chown -R www-data cyberdojo
chgrp -R www-data cyberdojo
bundle install
service apache2 restart
