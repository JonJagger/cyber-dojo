#!/usr/bin/env ruby

# This doesn't currently work if you are on a server built from the
# docker-compose.yml file. However, if you've done $docker-compose up
# and the languages-data-container is available you can do this...
#
# docker run --rm \
#    --volumes-from cyber-dojo-languages-data-container:ro \
#    ruby:2.1 bash -c ./var/www/cyber-dojo/languages/docker_list_all_images.rb
#
# After you have pulled a new cyberdojofoundation/language image
# you have to delete the runner cache inside the web server
# to force the web server to recreate it. Like this...
#
# docker exec cyberdojo_web_1 \
#    rm /var/www/cyber-dojo/caches/runner_cache.json

require 'json'

cyber_dojo_root = File.expand_path('..', File.dirname(__FILE__))

image_names = []
Dir.glob("#{cyber_dojo_root}/languages/*/*/manifest.json") do |file|
  manifest = JSON.parse(IO.read(file))
  image_names << (manifest['image_name'] + ' == ' + manifest['display_name'])
end

puts image_names.sort
