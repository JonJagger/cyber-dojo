#!/usr/bin/env ruby

# Issues unconditional 'docker pull <image_name> for all languages.

require 'json'

CYBER_DOJO_ROOT_DIR = '/var/www/cyber-dojo'

image_names = [ ]
Dir.glob("#{CYBER_DOJO_ROOT_DIR}/languages/*/*/manifest.json") do |file|
  manifest = JSON.parse(IO.read(file))
  image_names << manifest['image_name']
end

puts "this will take a good while..."
image_names.each do |image_name|
  cmd = "docker pull #{image_name}"
  print cmd + "\n"
  `#{cmd}`
end

puts "# -----------------------"
puts "# now refresh the language cache"
puts "$ cd /var/www/cyber-dojo/languages"
puts "$ ./cache.rb"
