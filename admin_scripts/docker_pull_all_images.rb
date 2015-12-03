#!/usr/bin/env ruby

# Issues unconditional 'docker pull <image_name> for all languages.

require 'json'

cyber_dojo_root = '/var/www/cyber-dojo'

image_names = []
Dir.glob("#{cyber_dojo_root}/languages/*/*/manifest.json") do |file|
  manifest = JSON.parse(IO.read(file))
  image_names << manifest['image_name']
end

puts "this may take a while..."
image_names.sort.each do |image_name|
  cmd = "docker pull #{image_name}"
  print cmd + "\n"
  `#{cmd}`
end

puts "# -----------------------"
puts "# now refresh the caches"
puts "$ cd #{cyber_dojo_root}/admin_scripts"
puts "$ ./refresh_all_caches.sh"
