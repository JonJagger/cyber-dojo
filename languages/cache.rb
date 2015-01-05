#!/usr/bin/env ruby

require_relative '../admin_scripts/lib_domain'

cache = { }
create_dojo.languages.each do |language|
  cache[language.display_name] = language.name
end

this_dir = File.expand_path('.', File.dirname(__FILE__))
manifest_filename = this_dir + '/' + 'cache.json'
File.open(manifest_filename, 'w') { |file|
  file.write(JSON.unparse(cache))
}
