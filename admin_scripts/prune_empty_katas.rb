#!/usr/bin/env ruby

require_relative 'lib_domain'

def empty?(avatar)
  !File.exist? avatar.path + '/increments.json'
end

ok,empty = [],[]

dots = Dots.new('working')
dojo.katas.each do |kata|
  print dots.line
  is_empty = kata.avatars.all?{|avatar| empty?(avatar)}
  empty << kata.id.to_s if is_empty
  ok    << kata.id.to_s if !is_empty
end

puts

dots = Dots.new('deleting')
empty.each do |id|
  print dots.line
  folder = dojo.katas[id].path
  rm_cmd = "rm -rf #{folder}"
  `#{rm_cmd}`
end

2.times{puts}
p "#{ok.length} ok"
p "#{empty.length} empty"
