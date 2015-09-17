#!/usr/bin/env ruby

require 'json'

cyber_dojo_root = '/var/www/cyber-dojo'

image_names = [ ]
Dir.glob("#{cyber_dojo_root}/languages/*/*/manifest.json") do |file|
  manifest = JSON.parse(IO.read(file))
  image_names << manifest['image_name']
end

puts image_names.sort
