#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/lib_domain'

dojo = create_dojo

languages_names = dojo.languages.collect {|language| language.name}

puts
renamed,rest,totals = { },{ },{ }
dot_count = 0
exceptions = [ ]
dojo.katas.each do |kata|
  begin
    if !languages_names.include? kata.original_language.name
      renamed[kata.original_language.name] ||= [ ]
      renamed[kata.original_language.name] << kata.id
    else
      rest[kata.language.name] ||= [ ]
      rest[kata.language.name] << kata.id
    end
    totals[kata.language.name] ||= 0
    totals[kata.language.name] += 1
  rescue Exception => error
    exceptions << error.message
  end
  dot_count += 1
  print "\rworking" + dots(dot_count)
end
puts
puts


puts '- - - - - - - - - - -'
puts 'Renamed'
count = 0
renamed.keys.sort.each do |name|
  dots = '.' * (32 - name.length)
  print " #{name}#{dots}"
  n = renamed[name].length
  count += n
  print number(n,5)
  print "  #{renamed[name].shuffle[0]}"
  if name == dojo.languages[name].new_name
    print " --> MISSING new_name "
  else
    print " --> " + dojo.languages[name].new_name
  end
  puts
end
print ' ' * (33)
print number(count,5)
puts
puts

puts '- - - - - - - - - - -'
puts 'Rest'
count = 0
rest.keys.sort.each do |name|
  dots = '.' * (32 - name.length)
  print " #{name}#{dots}"
  n = rest[name].length
  count += n
  print number(n,5)
  print "  #{rest[name].shuffle[0]}"
  print " --> MISSING new_name " if name != dojo.languages[name].new_name
  puts
end
print ' ' * (33)
print number(count,5)
puts
puts

puts '- - - - - - - - - - -'
puts 'Totals'
totals.sort_by{|k,v| v}.reverse.each do |name,count|
  dots = '.' * (32 - name.length)
  print " #{name}#{dots}"
  print number(count,5)
  puts
end
puts
puts

mention(exceptions)
