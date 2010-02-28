
class Avatar


  def initialize(kata, name)
    #TODO: check name is in NAMES
    @kata, @name = kata, name
  end

  def self.names
    %w( alligators badgers bears beavers buffalos camels cheetahs deer
              elephants frogs giraffes gophers gorillas hippos kangaroos koalas 
              lemurs lions pandas raccoons snakes squirrels wolves zebras )
    #avatars_dir = File.join(Rails.root,'public/images/avatars/*.jpg')
    #Dir[avatars_dir].collect{|name| name.basename.split('.').first.humanize }
  end
  
  def name
    @name
  end

  def increments
    eval locked_read(increments_filename)
  end

  def folder
	@kata.folder + '/' + name
  end

  def read_most_recent(manifest, test_log)
    if !File.exists?(folder) # start
      make_dir(folder)
      File.open(increments_filename, 'w') { |file| file.write([].inspect) }
      [] #save(manifest, test_log)
    else # restart
      my_increments = increments
      if my_increments.length != 0
        current_increment_folder = folder + '/' + (my_increments.length - 1).to_s
        restart_manifest = eval IO.read(current_increment_folder + '/' + 'manifest.rb')
        #need to do whole thing...
        manifest[:visible_files] = restart_manifest[:visible_files]
      end
      my_increments
    end
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

  def increments_filename
    folder + '/' + 'increments_manifest.rb'
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


