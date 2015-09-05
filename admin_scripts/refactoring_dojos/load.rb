#!/usr/bin/env ruby

# Retain the file-permissions (www-data:www-data)
# of the refactoring dojos when unzipping them.
# This is done with tar's p option.

`tar -C /var/www/cyber-dojo -xvpf refactoring_dojos.tgz`
