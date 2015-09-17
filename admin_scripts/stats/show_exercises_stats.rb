#!/usr/bin/env ruby

require_relative '../lib_domain'

exercises_names = dojo.exercises.collect {|exercise| exercise.name}

puts
renamed,rest,totals = { },{ },{ }
dot_count = 0
exceptions = [ ]
dojo.katas.each do |kata|
  begin
    if !exercises_names.include? kata.exercise.name
      renamed[kata.original_exercise.name] ||= [ ]
      renamed[kata.original_exercise.name] << kata.id
    else
      rest[kata.exercise.name] ||= [ ]
      rest[kata.exercise.name] << kata.id
    end
    totals[kata.exercise.name] ||= 0
    totals[kata.exercise.name] += 1
  rescue Exception => error
    exceptions << error.message
  end
  dot_count += 1
  print "\r " + dots(dot_count)
end
puts
puts

# - - - - - - - - - - - - - - - - - - - - - -
print "Renamed\n"
count = 0
renamed.keys.sort.each do |name|
  dots = '.' * (32 - name.length)
  print " #{name}#{dots}"
  n = renamed[name].length
  count += n
  print number(n,5)
  print "  #{renamed[name].shuffle[0]}"
  puts
end
print ' ' * (33)
print number(count,5)
puts
puts

# - - - - - - - - - - - - - - - - - - - - - -
print "Alphabetical\n"
count = 0
rest.keys.sort.each do |name|
  dots = '.' * (32 - name.length)
  print " #{name}#{dots}"
  n = rest[name].length
  count += n
  print number(n,5)
  print "  #{rest[name].shuffle[0]}"
  puts
end
print ' ' * (33)
print number(count,5)
puts
puts

# - - - - - - - - - - - - - - - - - - - - - -
print "Popularity\n"
totals.sort_by{|k,v| v}.reverse.each do |name,count|
  dots = '.' * (32 - name.length)
  print " #{name}#{dots}"
  print number(count,5)
  puts
end
puts
puts

mention(exceptions)