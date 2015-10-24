#!/usr/bin/env ruby

require_relative '../admin_scripts/lib_domain'
require_relative '../admin_scripts/cyberdojofoundation_docker_update_all.rb'

cyberdojo_foundation_docker_update_all

cache_filename = dojo.caches.path + Languages.cache_filename
`chmod 666 #{cache_filename}`
dojo.languages.refresh_cache
`chmod 444 #{cache_filename}`
`chown www-data:www-data #{cache_filename}`
