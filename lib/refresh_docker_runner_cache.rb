#!/usr/bin/env ruby

require_relative '../admin_scripts/lib_domain'

cache_filename = dojo.caches.path + DockerRunner.cache_filename
`chmod --silent 666 #{cache_filename}`
DockerRunner.new(dojo.caches).refresh_cache
`chmod 444 #{cache_filename}`
`chown www-data:www-data #{cache_filename}`
