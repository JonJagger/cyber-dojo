#!/usr/bin/env ruby

require_relative '../admin_scripts/lib_domain'

runner = DockerMachineRunner.new(dojo)
if runner.installed?
  p "docker-machine is installed"
  p "refreshing DockerMachineRunner cache"
  cache_filename = dojo.caches.path + runner.cache_filename
  `chmod --silent 666 #{cache_filename}`
  runner.refresh_cache
  `chmod 444 #{cache_filename}`
  `chown www-data:www-data #{cache_filename}`
else
  p "docker-machine is NOT installed"
end
