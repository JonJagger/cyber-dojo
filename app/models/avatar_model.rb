
class AvatarModel

  NAMES = %w( Alligators Badgers Bears Beavers Buffalos Camels Cheetahs Deer
              Elephants Frogs Giraffes Gophers Gorillas Hippos Kangaroos Koalas 
              Lemurs Lions Pandas Raccoons Snakes Squirrels Wolves Zebras )

  def initialize(kata, name)
    #TODO: check name is in NAMES
    @kata, @name = kata, name
  end

  def name
    @name
  end

  def increments
    eval locked_read(increments_filename)
  end

  def read_most_recent_files(visible_files, test_log, manifest)
    my_increments = []
    File.open(@kata.folder, 'r') do |f|
      flock(f) do |lock| 
        my_increments = locked_read_most_recent_files(visible_files, test_log, manifest) 
      end
    end
    my_increments
  end

  def save(visible_files, test_info, manifest)
    my_increments = []
    File.open(folder, 'r') do |f|
      flock(f) do |lock| 
        my_increments = locked_save(visible_files, test_info, manifest)
      end
    end
    my_increments
  end

  def read_increment(visible_files, number)
    increment_folder = folder + '/' + number.to_s
    visible_files.each do |filename,file|
      # no need to lock when reading these files. They are write-once-only
      file[:content] = IO.read(increment_folder  + '/' + filename)
    end
    increments
  end

  def folder
	@kata.folder + '/' + name
  end

private

  def locked_read_most_recent_files(visible_files, test_log, manifest)
    if !File.exists?(folder) # start
      make_dir(folder)
      File.open(increments_filename, 'w') do |file|
        file.write([].inspect)
      end
      save(visible_files, test_log, manifest)
    else # restart
      my_increments = increments
      current_increment_folder = folder + '/' + (my_increments.length - 1).to_s
      visible_files.each do |filename,file|
        # no need to lock when reading these files. They are write-once-only
        file[:content] = IO.read(current_increment_folder  + '/' + filename)
      end
      my_increments
    end
  end

  def locked_save(visible_files, test_info, manifest)
    my_increments = increments

    dst_folder = folder + '/' + my_increments.length.to_s
    make_dir(dst_folder)
    visible_files.each do |filename,file|
      #save_file(dst_folder, filename, file)
      manifest[:visible_files][filename][:content] = file[:content]
    end
    path = dst_folder + '/manifest.rb'
    File.open(path, 'w') do |fd|
      fd.write(manifest.inspect)
    end

 
    now = Time.now
    test_info[:time] = [now.year, now.month, now.day, now.hour, now.min, now.sec]
    test_info[:number] = increments.length

    my_increments << test_info
    File.open(increments_filename, 'w') { |file| file.write(my_increments.inspect) }
    my_increments
  end

  def increments_filename
    folder + '/' + 'increments_manifest.rb'
  end

end

#---------------------------------------------------------------

def make_dir(dir)
  Dir.mkdir(dir) if !File.exists? dir
end

def save_file(foldername, filename, file)
  path = foldername + '/' + filename
  # no need to lock when writing these files. They are write-once-only
  File.open(path, 'w') do |fd|
    filtered = makefile_filter(filename, file[:content])
    fd.write(filtered)
  end
  # .sh files (for example) need execute permissions
  File.chmod(file[:permissions], path) if file[:permissions]
end

# When editArea is used in the is_multi_files:true
# mode then the setting replace_tab_by_spaces: applies
# to ALL tabs (if set) or NONE of them (if not set).
# If it is not set then the default tab-width of the
# operating system seems to apply, which in Ubuntu
# is 8 spaces. There appears to be no way to alter the 
# tab-width in Ubuntu or in Firefox. Hence if you
# want tabs to expand to 4 spaces, as I do, you have to
# use replace_tab_by_spaces:=4 setting. This creates
# a problem for makefiles since they are tab sensitive.
# Hence this special filter, just for makefiles to 
# convert 4 leading spaces to a tab character.
def makefile_filter(name, content)
  if name.downcase == 'makefile'
    lines = []
    newline = Regexp.new('[\r]?[\n]')
    content.split(newline).each do |line|
      line = "\t" + line[4 .. line.length-1] if line[0..3] == "    "
      lines.push(line)
    end
    content = lines.join("\r\n")
  end
  content
end



