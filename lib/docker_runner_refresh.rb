#!/usr/bin/env ruby

require_relative '../admin_scripts/lib_domain'

runner = DockerRunner.new(dojo)
if runner.installed?
  puts 'docker is installed'

  puts 'setting runner=DockerRunner in config/cyber-dojo.json'
  config_filename = dojo.config_filename
  `cp #{runner.path}#{runner.config_filename} #{config_filename}`
  `chmod 444 #{config_filename}`
  `chown www-data:www-data #{config_filename}`

  puts 'refreshing DockerRunner cache'
  cache_filename = dojo.caches.path + runner.cache_filename
  `chmod --silent 666 #{cache_filename}`
  runner.refresh_cache
  `chmod 444 #{cache_filename}`
  `chown www-data:www-data #{cache_filename}`
else
  puts 'docker is NOT installed!!'
end

