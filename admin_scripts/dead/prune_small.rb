#!/usr/bin/env ruby

# A ruby script to prune folders containing old
# katas with very few traffic lights.
# Katas with a few traffic lights don't use a lot
# of inodes but there are a lot of them and unless
# regular pruning occurs a small server could run
# out of inodes. And they arguably don't want to
# appear on a read-only hub anyway.
#
# e.g. start by not deleting,
# eg with max_traffic_lights==1 and min_days_old==7
#   $./prune_small.rb 1 7 false
# this will print what will be deleted. Then
#   $./prune_small.rb 1 7 true
# to actually do the pruning

require './script_lib.rb'

max_traffic_light_count = ARGV[0].to_i
min_days_old = ARGV[1].to_i
do_delete = (ARGV[2] || "false")

prune(do_delete) { |traffic_light_count,days_old|
  traffic_light_count <= max_traffic_light_count and days_old >= min_days_old
}

puts '============================================'
puts 'This could have pruned the refactoring dojos'
puts 'Restore by unzipping'
puts '   refactoring_dojos.zip'
puts '============================================'
puts
