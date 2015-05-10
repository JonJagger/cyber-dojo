#!/usr/bin/env ruby

require_relative '../admin_scripts/lib_domain'

cache = { }
dojo.exercises.each do |exercise|
  cache[exercise.name] = exercise.instructions
end

this_dir = File.expand_path('.', File.dirname(__FILE__))
manifest_filename = this_dir + '/' + 'cache.json'
File.open(manifest_filename, 'w') { |file|
  file.write(JSON.unparse(cache))
}
