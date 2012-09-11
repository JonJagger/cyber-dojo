# A ruby script to prune folders containing old katas with very few traffic lights
# cyber-dojo is very heavy on Inodes so I need to reclaim as many as I can.
#
# start by not deleting with min traffic_lights==2 and min days_old==7
#   ruby prune.rb false 2 7
# this will print what will be deleted. Then
#   ruby prune.rb true 2 7
# to actually do the pruning


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
      stats[count] ||= [ ]   
      stats[count] << [id,days_old]
    end
  end
end

do_delete = (ARGV[0] || "false")
min_traffic_light_count = (ARGV[1] || "2").to_i
min_days_old = (ARGV[2] || "7").to_i


tally_yes = 0
tally_no = 0
stats.sort.each do |traffic_light_count,entries|
  entries.each do |id,days_old|
    if traffic_light_count <= min_traffic_light_count and days_old >= min_days_old
      tally_yes += 1
      inner_dir = id[0..1]   
      outer_dir = id[2..9]
      kata_dir = "katas/#{inner_dir}/#{outer_dir}"
      rm = "rm -rf " + kata_dir
      if do_delete == "true"
        system(rm)
      else
        print "will rm " + traffic_light_count.to_s + " " + id + " " + days_old.to_s + "\n"
      end
    else
      tally_no += 1
    end
  end
end

print tally_yes.to_s + " folders "
if do_delete == "false"
  print "will be "
end
print "deleted\n"

print tally_no.to_s + " folders "
if do_delete == "false"
  print "will not be "
else
  print "not "
end
print "deleted\n"
