#!/usr/bin/env ruby

# script to delete empty katas.
# running on 17th Sept 2015 deleted 7,553 empty katas
# leavng 28,842 non empty.
# It saved only 15389 inodes. Not worth doing.

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

print "\n"
print "#{ok.length} ok\n"
print "#{empty.length} empty\n"

dots = Dots.new('deleting')
empty.each do |id|
  print dots.line
  folder = dojo.katas[id].path
  rm_cmd = "rm -rf #{folder}"
  `#{rm_cmd}`
end

2.times { print "\n" }
