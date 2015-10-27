#!/usr/bin/env ruby

require_relative '../admin_scripts/lib_domain'

runner = Object.const_get(ARGV[0]).new(dojo.caches)
cache_filename = dojo.caches.path + runner.class.cache_filename
`chmod 666 #{cache_filename}`
runner.refresh_cache
`chmod 444 #{cache_filename}`
`chown www-data:www-data #{cache_filename}`
