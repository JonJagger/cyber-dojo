# A ruby script to display the count of katas per day
#
# ruby count.rb
# [2012,5,17, "Tue"] 14
# [2012,5,18, "Wed"] 26
# [2012,5,19, "Thu"] 32

require './script_lib.rb'

stats = { }
index('katas') do |kata_dir|
  begin
    manifest_filename = "#{kata_dir}/manifest.rb"
    if File.exists? manifest_filename
      manifest = eval IO.popen("cat #{manifest_filename}").read
      created = Time.mktime(*manifest[:created])
      ymd = [created.year, created.month, created.day, created.strftime('%a')]
      stats[ymd] ||= 0
      stats[ymd] += 1
    end
  rescue Exception => e
    print "---->Exception raised for #{kata_dir}: #{e.message}\n"
  end
end

stats.sort.each do |ymdw,n|
  print ymdw.inspect + "\t" + n.to_s + "\n"
end

