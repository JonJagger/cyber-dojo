
class Avatar

  def initialize(kata, name)
    @kata, @name = kata, name
  end

  def self.names
    %w( alligators buffalos camels cheetahs 
        frogs kangaroos koalas lemurs
        pandas raccoons squirrels wolves )
  end
  
  def name
    @name
  end

  def visible_files(n)
    path = @kata.folder + '/' + name + '/' + n.to_s + '/' + 'manifest.rb'
    eval IO.read(path)
  end
  
  def increments
    eval locked_read(increments_filename)
  end

  def read_most_recent(manifest)
    # load starting manifest
    manifest[:visible_files] = @kata.exercise.visible_files

    increments = []
    File.open(@kata.folder, 'r') do |f|
      flock(f) do |lock|
        increments = locked_read_most_recent(manifest)
      end
    end
    increments
  end

  def save(manifest, test_info)    
    my_increments = increments

    dst_folder = folder + '/' + my_increments.length.to_s
    make_dir(dst_folder)
    File.open(dst_folder + '/manifest.rb', 'w') { |fd| fd.write(manifest.inspect) }
 
    now = Time.now
    test_info[:time] = [now.year, now.month, now.day, now.hour, now.min, now.sec]
    test_info[:number] = my_increments.length
    my_increments << test_info
    File.open(increments_filename, 'w') { |file| file.write(my_increments.inspect) }
    my_increments
  end

  def folder
	@kata.folder + '/' + name
  end

private

  def increments_filename
    folder + '/' + 'increments_manifest.rb'
  end

  def locked_read_most_recent(manifest)
    if !File.exists?(folder) # start
      make_dir(folder)      
      File.open(increments_filename, 'w') { |file| file.write([].inspect) }
      []
    else # restart
      my_increments = increments
      if my_increments.length != 0
        current_increment_folder = folder + '/' + (my_increments.length - 1).to_s
        restart_manifest = eval IO.read(current_increment_folder + '/' + 'manifest.rb')
        manifest[:visible_files] = restart_manifest[:visible_files]
      end
      my_increments
    end
  end

end

#---------------------------------------------------------------

def make_dir(dir)
  Dir.mkdir(dir) if !File.exists? dir
end

def locked_read(path)
  result = []
  File.open(path, 'r') do |f|
    flock(f) { |lock| result = IO.read(path) }
  end
  result
end

def flock(file)
  success = file.flock(File::LOCK_EX)
  if success
    begin
      yield file
    ensure
      file.flock(File::LOCK_UN)
    end
  end
  return success
end


