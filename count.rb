# A ruby script to display the count of
# dojos per day, dojos per language, and dojos per exercise

require './script_lib.rb'

stats = { }
languages = { }
exercises = { }
index('katas') do |kata_dir|
  begin
    manifest_filename = "#{kata_dir}/manifest.rb"
    if File.exists? manifest_filename
      begin
        manifest = eval IO.popen("cat #{manifest_filename}").read
        created = Time.mktime(*manifest[:created])
        ymd = [created.year, created.month, created.day, created.strftime('%a')]
        stats[ymd] ||= 0
        stats[ymd] += 1
        language = manifest[:language]
        languages[language] ||= 0
        languages[language] += 1
        exercise = manifest[:exercise]
        exercises[exercise] ||= 0
        exercises[exercise] += 1
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
  puts n.to_s + "\t" + language
end

puts ""
puts "dojos per exercise"
puts "------------------"
exercises.sort.each do |exercise,n|
  puts n.to_s + "\t" + exercise
end

puts ""
