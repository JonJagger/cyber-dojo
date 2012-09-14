
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

def is_dir?(root_dir,sub_dir)
  dir = File.join(root_dir,sub_dir)
  File.directory?(dir) && sub_dir !='.' && sub_dir != '..'
end

def index(kata_root)
  Dir.entries(kata_root).each do |outer_dir| 
    if is_dir?(kata_root, outer_dir) 
      outer_path = File.join(kata_root, outer_dir)
      Dir.entries(outer_path).each do |inner_dir|
        if is_dir?(outer_path,inner_dir) 
          inner_path = File.join(outer_path, inner_dir)
          yield inner_path
        end
      end      
    end
  end
end

def prune_stats
  stats = { }
  index('katas') do |kata_dir|
    manifest_filename = "#{kata_dir}/manifest.rb"
    if File.exists?(manifest_filename)
      tally,count = traffic_light_count(kata_dir)
      manifest = eval IO.popen("cat #{manifest_filename}").read
      created = Time.mktime(*manifest[:created])
      days_old = ((Time.now - created) / 60 / 60 / 24).to_i
      stats[count] ||= [ ]    
      stats[count] << [manifest[:id],days_old]
    end
  end
  stats
end
