#!/usr/bin/env ruby

require_relative '../admin_scripts/lib_domain'

runner = DockerMachineRunner.new(dojo)
if runner.installed?
  puts 'docker-machine is installed'

  puts 'setting runner=DockerMachineRunner in config/cyber-dojo.json'
  config_filename = dojo.config_filename
  `chmod --silent 666 #{config_filename}`
  `cp #{runner.path}#{runner.config_filename} #{config_filename}`
  `chmod 444 #{config_filename}`
  `chown www-data:www-data #{config_filename}`

  puts 'refreshing DockerMachineRunner cache'
  cache_filename = dojo.caches.path + runner.cache_filename
  `chmod --silent 666 #{cache_filename}`
  runner.refresh_cache
  `chmod 444 #{cache_filename}`
  `chown www-data:www-data #{cache_filename}`
else
  puts 'docker-machine is NOT installed'
end
