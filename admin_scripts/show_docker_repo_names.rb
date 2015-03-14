#!/usr/bin/env ruby

require 'json'

me = File.expand_path(File.dirname(__FILE__))
root_folder = File.expand_path('..', me) + '/'  

image_names = [ ]
Dir.glob("#{root_folder}/languages/*/*/manifest.json") do |file|
  json = JSON.parse(IO.read(file))
  image_name = json['image_name']
  image_names << image_name if !image_name.nil?
end

puts image_names.sort
