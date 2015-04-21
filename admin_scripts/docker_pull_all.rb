#!/usr/bin/env ruby

require 'json'

CYBER_DOJO_ROOT_DIR = '/var/www/cyber-dojo'

image_names = [ ]
Dir.glob("#{CYBER_DOJO_ROOT_DIR}/languages/*/*/manifest.json") do |file|
  json = JSON.parse(IO.read(file))
  image_name = json['image_name']
  image_names << image_name if !image_name.nil?
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
