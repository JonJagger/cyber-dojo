#!/usr/bin/env ruby

require 'json'

CYBER_DOJO_ROOT_DIR = '/var/www/cyber-dojo'

image_names = [ ]
Dir.glob("#{CYBER_DOJO_ROOT_DIR}/languages/*/manifest.json") do |file|
  json = JSON.parse(IO.read(file))
  image_name = json['image_name']
  image_names << image_name if !image_name.nil?
end

puts image_names.sort
