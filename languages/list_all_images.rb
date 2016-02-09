#!/usr/bin/env ruby

# List all language+test's docker image name.
# Run it inside a docker container supporting ruby (eg web)
# with the languages data container mounted - this is what
# the associated list_all_images.sh does.

require 'json'

cyber_dojo_root = File.expand_path('..', File.dirname(__FILE__))

longest_test_name=""

image_names = {}
Dir.glob("#{cyber_dojo_root}/languages/*/*/manifest.json") do |file|
  manifest = JSON.parse(IO.read(file))
  language_name, test_name = manifest['display_name'].split(',').map { |s| s.strip }
  longest_test_name = test_name if test_name.size > longest_test_name.size
  full_image_name = manifest['image_name']
  image_name=full_image_name.split('/')[1].strip
  image_names[language_name] ||= {}
  image_names[language_name][test_name] = image_name
end

puts "#"
image_names.sort.map do |language_name,tests|
  puts "# #{language_name}"
  tests.sort.map do |name, image_name|
    dots = '.' * (longest_test_name.size - name.size)
    puts '#   ' + dots + ' ' + name + ' -> ' + image_name
  end
end
puts "#"

