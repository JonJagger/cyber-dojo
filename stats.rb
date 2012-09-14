# A ruby script to display the count of katas by size
# So the output below means there were 45 katas with 0 traffic lights
# and 55 katas with 1 traffic light, etc.
# The numbers following inside [ ] are the number of avatars in each kata
# So for example
#    34 2 [5,6] means there were 2 katas with 34 traffic lights
#               and those two katas had 5 and 6 avatars respetively.
#
# ruby stats.rb
# 0 45
# 1 55 [...]
# 2 42 [...]
# ...
# 34 2 [5, 6]
# 156 1 [8]
# 194 1 [3]

require './script_lib.rb'

stats = { }
index('katas') do |kata_dir|
  if File.exists? "#{kata_dir}/manifest.rb"
    tally,count = traffic_light_count(kata_dir)
    stats[count] ||= [ ]
    stats[count] << tally
  end
end

stats.sort.each do |count,tallies|
  printf("%3d %3d ",count, tallies.length)
  print tallies.sort.inspect if tallies.length <= 20
  printf("\n")
end

