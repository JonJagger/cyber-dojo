#!/usr/bin/env ruby

# You must retain the file-permissions (www-data:www-data)
# of the refactoring dojos when unzipping them.
# You do this with tar's p option.

# has to be run from cyber-dojo dir
# cd /var/www/cyber-dojo
# ./admin_scripts/refactoring_dojos/load.rb

cd /var/www/cyber-dojo
`tar -xvpf /var/www/cyber-dojo/admin_scripts/refactoring_dojos/refactoring_dojos.tgz`
