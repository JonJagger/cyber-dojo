#!/usr/bin/env ruby

# A ruby script to display stats on light-light diffs.

require File.dirname(__FILE__) + '/lib_domain'

$stats = { }

def collect_diff_stats(kata)
  #TODO
  count = kata.avatars.inject(0){|sum,avatar| sum + avatar.lights.length }
  $stats[count] ||= [ ]
  $stats[count] << kata.avatars.entries.length
end

def show_diff_stats
  #TODO
  $stats.sort.each do |count,tallies|
    printf("%3d %3d ",count, tallies.length)
    print tallies.sort.inspect if tallies.length <= 20
    printf("\n")
  end
end

def explain_output
  puts
  puts
  puts '# Explanation'
  puts '#'
  puts '#    34 2 [5,6]'
  puts '#'
  puts '# means there were 2 katas with 34 traffic lights'
  puts '# and those 2 katas had 5 and 6 avatars respectively.'
  puts '#'
  puts
end


puts
dot_count = 0
exceptions = [ ]
`rm -rf exceptions.log`


dojo = create_dojo
dojo.katas.each do |kata|
  begin
    collect_diff_stats(kata)
    dot_count += 1
    print "\r " + dots(dot_count)
  rescue Exception => error
    exceptions << error.message
  end
end


explain_output
show_diff_stats
mention(exceptions)
