# A ruby script to create a zip file of dojos whose total number
# of traffic-lights is greater Parameter-1 and
# who are at least Parameter-2 days old.
# This allows the subsequent deletion of said dojos
# which is important as cyber-dojo is very heavy on inodes.
#
# Step 1
#     ruby zipup.rb false 200 7
# if there are a lot of won't and you just want to see the wills
#     ruby zipup.rb false 200 7 | grep "will"
# then
#     ruby zipup.rb true 200 7
#
# Step 2 - sftp the zip file off the server.
#
# Step 3
#     ruby prune_large.rb false 200 7
#     ruby prune_large.rb true  200 7



def avatars
  %w(
      alligator buffalo cheetah deer
      elephant frog gorilla hippo
      koala lion moose panda
      raccoon snake wolf zebra
    )
end

def traffic_light_count(kata_dir)
  count = 0
  avatars.each do |avatar|
    inc_filename = "#{kata_dir}/#{avatar}/increments.rb"
    if File.exists? inc_filename
      incs = eval IO.popen("cat #{inc_filename}").read
      count += incs.length
    end
  end
  count
end

do_zip = (ARGV[0] || "false")
min_traffic_light_count = (ARGV[1] || "2").to_i
min_days_old = (ARGV[2] || "7").to_i

stats = { }
index = eval IO.popen('cat katas/index.rb').read
index.each do |entry|
  begin
    id = entry[:id]
    created = Time.mktime(*entry[:created])
    days_old = ((Time.now - created) / 60 / 60 / 24).to_i

    inner_dir = id[0..1]   
    outer_dir = id[2..9]
    kata_dir = "katas/#{inner_dir}/#{outer_dir}"
    manifest_name = "#{kata_dir}/manifest.rb"
    if File.exists?(manifest_name)
      count = traffic_light_count(kata_dir)
      zip_cmd = "zip -r zipped_dojos.zip " + kata_dir
      if count >= min_traffic_light_count and days_old >= min_days_old
        if do_zip == "true"
          system(zip_cmd)
        else
          print "will do: " + zip_cmd + "\n"
        end
      else
        print "won't do: " + zip_cmd + "\n" if do_zip == "false"
      end
    end
  end    
end


