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

# TODO: this should also look at the size of the diff, but as it is
#       its useful for deleting dojos with *no* traffic-lights
#       $./prune_small.rb 0 7 false
#       $./prune_small.rb 0 7 true

require_relative 'lib_domain'

def max_traffic_light_count; ARGV[0].to_i; end

def min_days_old; ARGV[1].to_i; end

def do_delete; (ARGV[2] || "false"); end

$exceptions = {}

def prune_stats
  dots = Dots.new('searching')
  stats = { }
  dojo.katas.select{|kata|
    !refactoring_ids.include?(kata.id.to_s)
  }.each do |kata|
    begin
      print dots.line
      lights_count = kata.avatars.inject(0){|sum,avatar| sum += avatar.lights.length}
      days_old = (kata.age / 60 / 60 / 24).to_i
      #p "#{kata.id} #{lights_count} #{days_old}"    
      stats[lights_count] ||= [ ]
      stats[lights_count] << [kata.id,days_old]
    rescue => error
      $exceptions[kata.id.to_s] = error.message
    end
  end
  stats
end

def prune
  tally_yes,tally_no = 0,0
  prune_stats.sort.each do |traffic_light_count,entries|
    entries.each do |id,days_old|
      if yield traffic_light_count, days_old
        tally_yes += 1
        rm_cmd = "rm -rf " + dojo.katas[id].path
        if do_delete == "true"
          system(rm_cmd)
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
  cf = (max_traffic_light_count === 0) ? '==' : '<='
  puts "Looking for: (lights #{cf} #{max_traffic_light_count}) && (days_old >= #{min_days_old})"
  if do_delete == 'false'
    print "#{tally_yes} katas will be deleted\n"
    print "#{tally_no} katas will not be deleted\n"
  else
    print "#{tally_yes} katas deleted\n"
    print "#{tally_no} katas not deleted\n"
  end  
end

#- - - - - - - - - - - - - - - - - - - - - -

prune { |traffic_light_count,days_old|
  traffic_light_count <= max_traffic_light_count and days_old >= min_days_old
}

mention($exceptions)
