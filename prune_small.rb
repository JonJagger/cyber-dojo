# A ruby script to prune folders containing old katas with very few traffic lights.
# Katas with a few traffic lights don't use a lot of inodes but there are a lot
# of them and unless regular pruning occurs the server will run out of inodes.
# Note: There is no real need to zipup old small katas before pruning.
#
# e.g. start by not deleting with max_traffic_lights==2 and min_days_old==7
#   >ruby prune_small.rb false 2 7
# this will print what will be deleted. Then
#   >ruby prune_small.rb true 2 7
# to actually do the pruning

require './script_lib.rb'

do_delete = (ARGV[0] || "false")
max_traffic_light_count = (ARGV[1] || "2").to_i
min_days_old = (ARGV[2] || "7").to_i

prune(do_delete) { |traffic_light_count,days_old|
  traffic_light_count <= max_traffic_light_count and days_old >= min_days_old
}

