#!/usr/bin/env ruby

require_relative '../admin_scripts/lib_domain'

this_dir = File.expand_path('.', File.dirname(__FILE__))
manifest_filename = this_dir + '/' + 'cache.json'
File.open(manifest_filename, 'w') { |file|
  cache = dojo.languages.map { |language| language.display_name }
  file.write(JSON.unparse(cache))
}
