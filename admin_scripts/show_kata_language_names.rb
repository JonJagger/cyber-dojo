#!/usr/bin/env ruby

require_relative 'lib_domain'


dojo = create_dojo

puts
names = { }
dot_count = 0
dojo.katas.each do |kata|
  name = kata.manifest['language']
  names[name] ||=  []
  names[name] << kata.id
  dot_count += 1
  print "\rworking" + dots(dot_count)
end
puts
puts

names.keys.sort.each do |name| 
  p "#{name} #{names[name].size} #{names[name][0]}"
end

