#!/usr/bin/env ruby

require_relative '../../app/domain'

def explain_output
  lines = [
    '',
    'frequency of katas in 2-digit katas/sub-folder',
    '',
    ' 1...........................................................59',
    ' 2................................................................64',
    ' 3...........................................43',
    ' 4.......................23',
    ' 5............12',
    ' 6..2',
    ' 7...3',
    '',
    'means',
    ' 59 sub-folders have 1 kata',
    ' 64 sub-folders have 2 katas',
    ' 43 sub-folders have 3 katas',
    ' etc',
    ''
  ]
  lines.each{|line| puts '# ' + line}
end

if ARGV[0] == "help"
  explain_output
  exit
end

puts
totals = { }
dot_count = 0
dojo.katas.each do |kata|
  smid = kata.id.to_s[0..1]
  totals[smid] ||= 0
  totals[smid] += 1
  dot_count += 1
  print "\rworking" + dots(dot_count)
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

print "frequencies (#{tally}/256)\n"
print "\n"
freqs.sort.each do |count,freq|
  print number(count,5) + ' ' + ('.' * freq) + freq.to_s + "\n"
end
puts
puts
