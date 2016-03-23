
def avatars
  %w(
      alligator buffalo cheetah deer
      elephant frog gorilla hippo
      koala lion moose panda
      raccoon snake wolf zebra
    )
end

def readfile(filename)
  `cat #{filename}`
end

def traffic_light_count(kata_dir)
  tally,count = 0,0
  avatars.each do |avatar|
    inc_filename = "#{kata_dir}/#{avatar}/increments.rb"
    if File.exists? inc_filename
      incs = eval readfile(inc_filename)
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
          id = outer_dir + inner_dir
          yield inner_path, id
        end
      end
    end
  end
end

def prune_stats
  stats = { }
  index('katas') do |kata_dir|
    manifest_filename = "#{kata_dir}/manifest.rb"
    if File.exists? manifest_filename
      tally,count = traffic_light_count(kata_dir)

      begin
        content = "# encoding: utf-8\n\n" + readfile(manifest_filename)
        manifest = eval content
        created = Time.mktime(*manifest[:created])
        days_old = ((Time.now - created) / 60 / 60 / 24).to_i
        stats[count] ||= [ ]
        stats[count] << [manifest[:id],days_old]
      rescue Exception => e
        puts "Exception from #{kata_dir}"
      end
    end
  end
  stats
end

def prune(do_delete)
  tally_yes = 0
  tally_no = 0
  if do_delete == "false"
    print "        " + "kata" + "       " + "rags" + "\t" + "days-old" + "\n"
  end
  prune_stats.sort.each do |traffic_light_count,entries|
    entries.each do |id,days_old|
      if yield traffic_light_count, days_old
        tally_yes += 1
        inner_dir = id[0..1]
        outer_dir = id[2..9]
        kata_dir = "katas/#{inner_dir}/#{outer_dir}"
        rm = "rm -rf " + kata_dir
        if do_delete == "true"
          system(rm)
          print "."
        else
          print "will rm " + id + " " + traffic_light_count.to_s + "\t" + days_old.to_s + "\n"
        end
        $stdout.flush
      else
        tally_no += 1
      end
    end
  end

  print "\n" + tally_yes.to_s + " katas "
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
end
