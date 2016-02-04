#!/usr/bin/env ruby

#
# Assuming the web container is called os_web_1 you can run this via
#
#   $ docker exec os_web_1 bash -c "./languages/list_all_images.rb"
#

require 'json'

cyber_dojo_root = File.expand_path('..', File.dirname(__FILE__))

image_names = []
Dir.glob("#{cyber_dojo_root}/languages/*/*/manifest.json") do |file|
  manifest = JSON.parse(IO.read(file))
  image_names << (manifest['image_name'] + ' == ' + manifest['display_name'])
end

puts image_names.sort
