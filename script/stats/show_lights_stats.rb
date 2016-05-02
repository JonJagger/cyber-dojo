#!/usr/bin/env ruby

# A ruby script to display counts of katas by size

require_relative '../lib_domain'

def explain_output
  lines = [
    '',
    'traffic-light statistics',
    '',
    '    34 2 [5,6]',
    '',
    ' means there were 2 katas with 34 traffic lights',
    ' and those 2 katas had 5 and 6 avatars respectively.',
    ''
  ]
  lines.each{|line| puts '# ' + line}
end

$stats = {}

def collect_light_stats(kata)
  count = kata.avatars.inject(0) { |sum,avatar| sum + avatar.lights.length }
  $stats[count] ||= []
  $stats[count] << kata.avatars.entries.length
end

def show_light_stats
  puts
  puts
  $stats.sort.each do |count,tallies|
    printf("%3d %3d ",count, tallies.length)
    print tallies.sort.inspect if tallies.length <= 20
    puts
  end
end

# - - - - - - - - - - - - - - - - - - - -

if ARGV[0] == 'help'
  explain_output
  exit
end

puts
dot_count = 0
exceptions = [ ]
dojo.katas.each do |kata|
  begin
    collect_light_stats(kata)
    dot_count += 1
    print "\rworking" + dots(dot_count)
  rescue Exception => error
    exceptions << error.message
  end
end

show_light_stats
mention(exceptions)
puts
