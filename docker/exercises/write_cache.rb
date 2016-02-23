#!/usr/bin/env ruby

# Make app/exercises/cache.json file
# Do this before creating a new cyberdojofoundation/exercises image
# or new cyber-dojo-exercises data-container

host_exercises_root = ARGV[0]
require_relative '../models/domain'
ENV['CYBER_DOJO_EXERCISES_ROOT'] = host_exercises_root
ENV['CYBER_DOJO_DISK_CLASS'] = 'HostDisk'
dojo.exercises.write_cache
