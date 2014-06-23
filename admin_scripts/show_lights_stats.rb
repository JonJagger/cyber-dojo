#!/usr/bin/env ruby

require File.expand_path(File.dirname(__FILE__)) + '/lib_domain'

# A ruby script to display the count of katas by size
# For example...
#    ...
#    34 2 [5,6]
#    ...
# means there were 2 katas with 34 traffic lights
# and those 2 katas had 5 and 6 avatars respectively.
#
# 0 45
# 1 55 [...]
# 2 42 [...]
# ...
# 34 2 [5, 6]
# 156 1 [8]
# 194 1 [3]

dojo = create_dojo

print "\n"
stats = { }
dot_count = 0
dojo.katas.each do |kata|
  begin
    count = kata.avatars.inject(0){|sum,avatar| sum + avatar.lights.length }
    stats[count] ||= [ ]
    stats[count] << kata.avatars.entries.length
    dot_count += 1
    print "\r " + dots(dot_count)
  rescue Exception => e
    puts e.message
  end
end
print "\n"
print "\n"

stats.sort.each do |count,tallies|
  printf("%3d %3d ",count, tallies.length)
  print tallies.sort.inspect if tallies.length <= 20
  printf("\n")
end
