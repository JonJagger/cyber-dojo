# A ruby script to display the count of
# dojos per day, dojos per language, and dojos per exercise
# to see the ids of all counted dojos (in their catagories)
# $ruby count.rb true

require './script_lib.rb'

show_ids = (ARGV[0] || "false")

stats = { }
languages = { }
exercises = { }
index('katas') do |kata_dir,id|
  begin
    manifest_filename = "#{kata_dir}/manifest.rb"
    if File.exists? manifest_filename
      begin
        content = "# encoding: utf-8\n\n" + readfile(manifest_filename)
        manifest = eval content
        created = Time.mktime(*manifest[:created])
        ymd = [created.year, created.month, created.day, created.strftime('%a')]
        stats[ymd] ||= 0
        stats[ymd] += 1
        language = manifest[:language]
        languages[language] ||= [ ]
        languages[language] << id
        exercise = manifest[:exercise]
        exercises[exercise] ||=  [ ]
        exercises[exercise] << id
      rescue Exception => e
        puts "Exception from #{kata_dir}"        
      end
    end
  rescue Exception => e
    puts "---->Exception raised for #{kata_dir}: #{e.message}"
  end
end

puts ""
puts "dojos per day"
puts "-------------"
stats.sort.each do |ymdw,n|
  puts ymdw.inspect + "\t" + n.to_s
end

puts ""
puts "dojos per language"
puts "------------------"
languages.sort.each do |language,n|
  if show_ids == "true"
    puts language + "\t" + n.to_s
  else
    puts n.length.to_s + "\t" + language
  end
end

puts ""
puts "dojos per exercise"
puts "------------------"
exercises.sort.each do |exercise,n|
  if show_ids == "true"
    puts exercise + "\t" + n.to_s
  else
    puts n.length.to_s + "\t" + exercise
  end
end

puts ""
