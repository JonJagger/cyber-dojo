# A ruby script to display the count of katas per day
#
# ruby count.rb
# [2012,5,17, "Tue"] 14
# [2012,5,18, "Wed"] 26
# [2012,5,19, "Thu"] 32

require './script_lib.rb'

stats = { }
exercises = { }
languages = { }
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
        exercise = manifest[:exercise]
        exercises[exercise] ||= 0
        exercises[exercise] += 1
        language = manifest[:language]
        languages[language] ||= 0
        languages[language] += 1
      rescue Exception => e
        puts "Exception from #{kata_dir}"        
      end
    end
  rescue Exception => e
    print "---->Exception raised for #{kata_dir}: #{e.message}\n"
  end
end

print "\n"
print "dojos per day" + "\n"
print "-------------" + "\n"
stats.sort.each do |ymdw,n|
  print ymdw.inspect + "\t" + n.to_s + "\n"
end

print "\n"
print "dojos per language" + "\n"
print "------------------" + "\n"
languages.sort.each do |language,n|
  print n.to_s + "\t" + language + "\n"
end

print "\n"
print "dojos per exercise" + "\n"
print "------------------" + "\n"
exercises.sort.each do |exercise,n|
  print n.to_s + "\t" + exercise + "\n"
end

print "\n"
