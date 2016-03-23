#!/usr/bin/ruby

require 'json'

node = ARGV[0]
if node.nil?
  p "./cdf_docker_machine_pull_all.rb <NODE>"
  exit
end

images_names = []
cyber_dojo_root = '/var/www/cyber-dojo'
Dir.glob("#{cyber_dojo_root}/languages/*/*/manifest.json") do |filename|
  manifest = JSON.parse(IO.read(filename))
  images_names << manifest['image_name']
end

images_names.sort.each do |image_name|
  command = "sudo -u cyber-dojo docker-machine ssh #{node} -- sudo docker pull #{image_name}"
  p command
  `#{command}`
end

command = "sudo -u cyber-dojo docker-machine ssh #{node} -- sudo service docker restart"
p command
`#{command}`

