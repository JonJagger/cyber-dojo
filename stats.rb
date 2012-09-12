# A ruby script to display the count of dojos by size
# So the output below means there were 45 dojos with 0 traffic lights
# and 55 dojos with 1 traffic light, etc.
#
# ruby stats.rb
# 0 45
# 1 55
# 2 42
# ...
# 156 1
# 194 1

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
      stats[count] ||= 0 
      stats[count] += 1
    end
  end    
end

stats.sort.each do |count,tally|
  printf("%3d %3d\n", count, tally)
end

