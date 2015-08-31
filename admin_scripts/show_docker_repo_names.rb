#!/usr/bin/env ruby

require 'json'

CYBER_DOJO_ROOT_DIR = '/var/www/cyber-dojo'

image_names = [ ]
Dir.glob("#{CYBER_DOJO_ROOT_DIR}/languages/*/*/manifest.json") do |file|
  manifest = JSON.parse(IO.read(file))
  image_names << manifest['image_name']
end

puts image_names.sort
