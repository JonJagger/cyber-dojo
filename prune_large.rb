# A ruby script to prune folders containing old katas with a lot of traffic lights.
# Katas with a lot of traffic lights use a lot of inodes and unless
# regular pruning occurs the server will run out of inodes.
#
# start by not deleting, eg with min traffic_lights==300 and min days_old==7
#   >ruby prune_large.rb false 300 7
# this will print what will be deleted. Then
#   >ruby prune_large.rb true 300 7
# to actually do the pruning

require './script_lib.rb'

do_delete = (ARGV[0] || "false")
min_traffic_light_count = (ARGV[1] || "50").to_i
min_days_old = (ARGV[2] || "7").to_i

prune(do_delete) { |traffic_light_count,days_old|
  traffic_light_count >= min_traffic_light_count and days_old >= min_days_old
}
