#!/usr/bin/env ruby

require_relative '../admin_scripts/lib_domain'

runner = DockerRunner.new(dojo)
if runner.installed?
  puts 'docker is installed'
  puts 'refreshing DockerRunner cache'
  cache_filename = dojo.caches.path + runner.cache_filename
  `chmod --silent 666 #{cache_filename}`
  runner.refresh_cache
  `chmod 444 #{cache_filename}`
  `chown www-data:www-data #{cache_filename}`
else
  puts 'docker is NOT installed!!'
end

