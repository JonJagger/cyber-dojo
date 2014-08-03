#!/usr/bin/env ruby

# Script to show frequency of katas by first 2 digits of their id.
# If there is a bias in the generation of random kata ids this
# may help show it. For example, suppose the output is
#
# Frequencies (221/255)
#
#    1................................................................64
#    2..........................................................................74
#    3...........................................43
#    4.......................23
#    5............12
#    6..2
#    7...3
#
# What are we counting?
# The number of katas underneath the 2-digit katas/sub-folder
# eg katas/34
#    katas/F8 etc
#
# 64 sub-folders have 1 kata
# 74 sub-folders have 2 katas
# 43 sub-folders have 3 katas
# 23 sub-folders have 4 katas
# 12 sub-folders have 5 katas
#  2 sub-folders have 6 katas
#  3 sub-folders have 7 katas
#

require File.dirname(__FILE__) + '/lib_domain'

dojo = create_dojo

puts
totals = { }
dot_count = 0
dojo.katas.each do |kata|
  smid = kata.id.to_s[0..1]
  totals[smid] ||= 0
  totals[smid] += 1
  dot_count += 1
  print "\r " + dots(dot_count)
end
puts
puts

freqs = { }
tally = 0
totals.each do |smid,count|
  freqs[count] ||= 0
  freqs[count] += 1
  tally += 1
end

print "Frequencies (#{tally}/256)\n"
print "\n"
freqs.sort.each do |count,freq|
  print number(count,5) + ' ' + ('.' * freq) + freq.to_s + "\n"
end
puts
puts
