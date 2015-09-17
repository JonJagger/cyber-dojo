#!/usr/bin/env ruby

# A ruby script to prune folders containing old katas with very few traffic lights.
# Katas with a few traffic lights don't use a lot of inodes but there are a lot of
# them and unless regular pruning occurs a small server could run out of inodes. 
#
# e.g. start by not deleting,
# eg with max_traffic_lights==1 and min_days_old==7
#   $./prune_small.rb 1 7 false
# this will print what will be deleted. Then
#   $./prune_small.rb 1 7 true
# to actually do the pruning

require_relative 'lib_domain'

def prune_stats
  n,max = 0,50  
  stats = { }
  dojo.katas.select{|kata|
    !refactoring_ids.include?(kata.id.to_s)
  }.each do |kata|
    begin
      lights_count = kata.avatars.inject(0){|sum,avatar| sum += avatar.lights.length}
      days_old = (kata.age / 60 / 60 / 24).to_i
      #p "#{kata.id} #{lights_count} #{days_old}"    
      stats[lights_count] ||= [ ]
      stats[lights_count] << [kata.id,days_old]
    rescue
      puts "Exception from #{kata.id.to_s}"      
    end
    n += 1; break if n >= max
  end
  stats
end

def prune(do_delete)
  tally_yes,tally_no = 0,0
  prune_stats.sort.each do |traffic_light_count,entries|
    entries.each do |id,days_old|
      if yield traffic_light_count, days_old
        tally_yes += 1
        rm_cmd = "rm -rf " + dojo.katas[id].path
        if do_delete == "true"
          #system(rm_cmd)
          print "#{rm_cmd}\n"
          print "."
        else
          print 'Will rm ' + id[0..1]+'/'+id[2..-1] +
                ' lights=' + traffic_light_count.to_s +
                ' days_old='+days_old.to_s + "\n"
        end
        $stdout.flush
      else
        tally_no += 1
      end
    end
  end
  print "\n"
  if do_delete == 'false'
    print "#{tally_yes} katas will be deleted\n"
    print "#{tally_no} katas will not be deleted\n"
  else
    print "#{tally_yes} katas deleted\n"
    print "#{tally_no} katas not deleted\n"
  end  
end

#- - - - - - - - - - - - - - - - - - - - - -

max_traffic_light_count = ARGV[0].to_i
min_days_old = ARGV[1].to_i
do_delete = (ARGV[2] || "false")

puts "Looking for (lights <= #{max_traffic_light_count}) && (days_old >= #{min_days_old})"

prune(do_delete) { |traffic_light_count,days_old|
  traffic_light_count <= max_traffic_light_count and days_old >= min_days_old
}
