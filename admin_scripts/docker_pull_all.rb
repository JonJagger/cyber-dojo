require 'json'

CYBER_DOJO_ROOT_DIR = ARGV[0]
if CYBER_DOJO_ROOT_DIR === nil
  puts "ruby docker_pull_all.rb [root-dir]"
  exit
end

image_names = [ ]
Dir.glob("#{CYBER_DOJO_ROOT_DIR}/languages/*/manifest.json") do |file|
  json = JSON.parse(IO.read(file))
  image_name = json['image_name']
  image_names << image_name if image_name != nil
end

image_names.each do |image_name|
  cmd = "docker pull #{image_name}"
  p cmd
  `#{cmd}`
end
