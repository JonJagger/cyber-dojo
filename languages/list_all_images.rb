#!/usr/bin/env ruby

# List all language+test's docker image name.
# Run it inside a docker container supporting ruby (eg web)
# with the languages data container mounted - this is what
# the associated list_all_images.sh does.

require 'json'

cyber_dojo_home = File.expand_path('..', File.dirname(__FILE__))

$longest_test=""
$longest_language=""

def max_size(lhs, rhs)
  lhs.size > rhs.size ? lhs : rhs
end

images = {}
Dir.glob("#{cyber_dojo_home}/languages/*/*/manifest.json") do |file|
  manifest = JSON.parse(IO.read(file))
  language, test = manifest['display_name'].split(',').map { |s| s.strip }
  $longest_language = max_size($longest_language, language)
  $longest_test = max_size($longest_test, test)
  image=manifest['image_name'].split('/')[1].strip
  images[language] ||= {}
  images[language][test] = image
end

def spacer(longest, name)
  ' ' * (longest.size - name.size)
end

def show(language, test, image)
  language_spacer = spacer($longest_language, language)
  test_spacer = spacer($longest_test, test)
  spacer = ' ' * 5
  puts language + language_spacer + spacer + test + test_spacer + spacer + image
end

show('LANGUAGE', 'TESTS', 'IMAGE')
images.sort.map do |language,tests|
  tests.sort.map do |test, image|
    show(language, test, image)
  end
end

