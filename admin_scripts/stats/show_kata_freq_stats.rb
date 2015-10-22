#!/usr/bin/env ruby

# A ruby script to display the count of
#   dojos per day
#   dojos per language
#   dojos per exercise
# to see the ids of all counted dojos (in their catagories)
# append true to the command line

require_relative '../lib_domain'

show_ids = (ARGV[0] || "false")

puts
days = {}
weekdays = {}
languages = {}
exercises = {}
dot_count = 0
exceptions = []
dojo.katas.each do |kata|
  begin
    id = kata.id.to_s
    created = kata.created
    ymd = [created.year, created.month, created.day, created.strftime('%a')]
    days[ymd] ||= 0
    days[ymd] += 1
    weekdays[ymd[3]] ||= 0
    weekdays[ymd[3]] += 1
    language = kata.language.name
    languages[language] ||= []
    languages[language] << id
    exercise = kata.exercise.name
    exercises[exercise] ||= []
    exercises[exercise] << id
  rescue Exception => error
    exceptions << error.message
  end
  dot_count += 1
  print "\r " + dots(dot_count)
end
puts
puts

puts
puts "per day"
puts "-------"
days.sort.each do |ymdw,n|
  puts ymdw.inspect + "\t" + n.to_s
end
puts

puts "per week day"
puts "------------"
['Sat','Sun','Mon','Tue','Wed','Thu','Fri'].each do |day|
  puts day.to_s + "\t" + weekdays[day].to_s
end
puts

puts "language freq"
puts "-------------"
languages.sort_by{|k,v| v.length}.reverse.each do |language,n|
  if show_ids == "true"
    puts language + "\t" + n.to_s
  else
    puts n.length.to_s + "\t" + language
  end
end
puts

puts "exercise freq"
puts "-------------"
exercises.sort_by{|k,v| v.length}.reverse.each do |exercise,n|
  if show_ids == "true"
    puts exercise + "\t" + n.to_s
  else
    puts n.length.to_s + "\t" + exercise
  end
end
puts

mention(exceptions)
