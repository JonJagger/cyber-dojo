# A ruby script to display the count of dojos by size
# So the output below means there were 45 dojos with 0 traffic lights
# and 55 dojos with 1 traffic light, etc.
# The numbers following inside [ ] are the number of avatars in the dojos
# So for example
#    34 2 [5,6] means there were 2 dojos with 34 traffic lights
#               and those two dojos had 5 and 6 avatars respetively.
#
# ruby stats.rb
# 0 45
# 1 55 [...]
# 2 42 [...]
# ...
# 34 2 [5, 6]
# 156 1 [8]
# 194 1 [3]

def avatars
  %w(
      alligator buffalo cheetah deer
      elephant frog gorilla hippo
      koala lion moose panda
      raccoon snake wolf zebra
    )
end

def traffic_light_count(kata_dir)
  tally,count = 0,0
  avatars.each do |avatar|
    inc_filename = "#{kata_dir}/#{avatar}/increments.rb"
    if File.exists? inc_filename
      incs = eval IO.popen("cat #{inc_filename}").read
      if incs.length > 0
        tally += 1
        count += incs.length
      end
    end
  end
  [tally,count]
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
      tally,count = traffic_light_count(kata_dir)
      stats[count] ||= [ ]
      stats[count] << tally
    end
  end    
end

stats.sort.each do |count,tallies|
  printf("%3d %3d ",count, tallies.length)
  print tallies.sort.inspect if tallies.length <= 20
  printf("\n")
end

