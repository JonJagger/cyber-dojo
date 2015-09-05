#!/usr/bin/env ruby

# You must retain the file-permissions (www-data:www-data)
# of the refactoring dojos when unzipping them.
# You do this with tar's p option.

`tar -C /var/www/cyber-dojo -xvpf refactoring_dojos.tgz`
