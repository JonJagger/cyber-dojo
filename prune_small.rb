# A ruby script to prune folders containing old katas with very few traffic lights
# cyber-dojo is very heavy on Inodes so I need to reclaim as many as I can.
# There is no real need to zipup old small katas before pruning.
#
# eg start by not deleting with max traffic_lights==2 and min days_old==7
#   ruby prune_small.rb false 2 7
# this will print what will be deleted. Then
#   ruby prune_small.rb true 2 7
# to actually do the pruning

require './script_lib.rb'

do_delete = (ARGV[0] || "false")
max_traffic_light_count = (ARGV[1] || "2").to_i
min_days_old = (ARGV[2] || "7").to_i

tally_yes = 0
tally_no = 0
if do_delete == "false"
  print "        " + "kata" + "       " + "rgb" + "\t" + "days-old" + "\n"
end
prune_stats.sort.each do |traffic_light_count,entries|
  entries.each do |id,days_old|
    if traffic_light_count <= max_traffic_light_count and days_old >= min_days_old
      tally_yes += 1
      inner_dir = id[0..1]   
      outer_dir = id[2..9]
      kata_dir = "katas/#{inner_dir}/#{outer_dir}"
      rm = "rm -rf " + kata_dir
      if do_delete == "true"
        system(rm)
      else
        print "will rm " + id + " " + traffic_light_count.to_s + "\t" + days_old.to_s + "\n"
      end
    else
      tally_no += 1
    end
  end
end

print tally_yes.to_s + " katas "
if do_delete == "false"
  print "will be "
end
print "deleted" + "\n"

print tally_no.to_s + " katas "
if do_delete == "false"
  print "will not be "
else
  print "not "
end
print "deleted" + "\n"
