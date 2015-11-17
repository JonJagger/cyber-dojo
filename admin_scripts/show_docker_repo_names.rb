#!/usr/bin/env ruby

require 'json'

cyber_dojo_root = File.expand_path('..', File.dirname(__FILE__))

image_names = []
Dir.glob("#{cyber_dojo_root}/languages/*/*/manifest.json") do |file|
  manifest = JSON.parse(IO.read(file))
  image_names << (manifest['image_name'] + ' == ' + manifest['display_name'])
end

puts image_names.sort
