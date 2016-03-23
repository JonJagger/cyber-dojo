# A ruby script to create a zip file of katas whose total number
# of traffic-lights is greater than Parameter-1 and
# that are at least Parameter-2 days old.
# This allows the subsequent deletion of said katas
# which is important as cyber-dojo is very heavy on inodes.
#
# Step 1
#     >ruby zipup.rb false 200 7
# if there are a lot of won't and you just want to see the wills
#     >ruby zipup.rb false 200 7 | grep "will"
# then
#     >ruby zipup.rb true 200 7
#
# Step 2 - sftp the zip file off the server.
#
# Step 3
#     >ruby prune_large.rb false 200 7
#     >ruby prune_large.rb true  200 7

require './script_lib.rb'

do_zip = (ARGV[0] || "false")
min_traffic_light_count = (ARGV[1] || "2").to_i
min_days_old = (ARGV[2] || "7").to_i

tally_yes = 0
tally_no = 0
stats = { }
index('katas') do |kata_dir|
  manifest_filename = "#{kata_dir}/manifest.rb"
  if File.exists?(manifest_filename)
    begin
      manifest = eval IO.popen("cat #{manifest_filename}").read
      created = Time.mktime(*manifest[:created])
      days_old = ((Time.now - created) / 60 / 60 / 24).to_i
      tally,count = traffic_light_count(kata_dir)
      zip_cmd = "zip -r zipped_dojos.zip " + kata_dir
      if count >= min_traffic_light_count and days_old >= min_days_old        
        tally_yes += 1
        if do_zip == "true"
          system(zip_cmd)
        else
          print "will do: " + zip_cmd + "\n"
        end
      else
        tally_no += 1
        print "won't do: " + zip_cmd + "\n" if do_zip == "false"
      end
    rescue Exception => e
        puts "Exception from #{kata_dir}"      
    end
  end
end

print tally_yes.to_s + " katas "
if do_zip == "false"
  print "will be "
end
print "zipped\n"

print tally_no.to_s + " katas "
if do_zip == "false"
  print "will not be "
else
  print "not "
end
print "zipped\n"


