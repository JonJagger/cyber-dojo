#!/usr/bin/env ruby

require_relative '../admin_scripts/lib_domain'

cache_filename = dojo.exercises.path + Exercises.cache_filename
`chmod 666 #{cache_filename}`
dojo.exercises.refresh_cache
`chmod 444 #{cache_filename}`
`chown www-data:www-data #{cache_filename}`