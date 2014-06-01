#!/usr/bin/env ruby

# A ruby script to display the count of
#   dojos per day
#   dojos per language
#   dojos per exercise
# to see the ids of all counted dojos (in their catagories)
# append true to the command line

require File.expand_path(File.dirname(__FILE__)) + '/lib_domain'

show_ids = (ARGV[0] || "false")

dojo = create_dojo

print "\n"
stats,languages,exercises = { },{ },{ }
dot_count = 0
dojo.katas.each do |kata|
  begin
    id = kata.id.to_s
    created = kata.created
    ymd = [created.year, created.month, created.day, created.strftime('%a')]
    stats[ymd] ||= 0
    stats[ymd] += 1
    language = kata.language.name
    languages[language] ||= [ ]
    languages[language] << id
    exercise = kata.exercise.name
    exercises[exercise] ||=  [ ]
    exercises[exercise] << id
  rescue Exception => e
    puts "---->Exception raised for #{id}: #{e.message}"
  end
  dot_count += 1
  print "\r " + dots(dot_count)
end
print "\n"
print "\n"

puts ""
puts "dojos per day"
puts "-------------"
stats.sort.each do |ymdw,n|
  puts ymdw.inspect + "\t" + n.to_s
end

puts ""
puts "dojos per language"
puts "------------------"
languages.sort_by{|k,v| v.length}.reverse.each do |language,n|
  if show_ids == "true"
    puts language + "\t" + n.to_s
  else
    puts n.length.to_s + "\t" + language
  end
end

puts ""
puts "dojos per exercise"
puts "------------------"
exercises.sort_by{|k,v| v.length}.reverse.each do |exercise,n|
  if show_ids == "true"
    puts exercise + "\t" + n.to_s
  else
    puts n.length.to_s + "\t" + exercise
  end
end

puts ""
