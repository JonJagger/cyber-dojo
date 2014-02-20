
class Disk

  def file_separator
    File::SEPARATOR
  end
  
  def write(dir, filename, object)
    pathed_filename = dir + file_separator + filename
    make_dir(pathed_filename)
    if object.is_a? String
      File.open(pathed_filename, 'w') do |fd|
        fd.write(object)
      end
      execute_permission = 0755
      File.chmod(execute_permission, pathed_filename) if pathed_filename =~ /\.sh/    
    else
      # The newline is to silence git's "\ No newline at end of file"
      File.open(pathed_filename, 'w') { |file| file.write(object.inspect + "\n") }
    end    
  end
  
  def read(dir, filename)
    IO.read(dir + file_separator + filename)
  end
  
  def symlink(old_name, new_name)
   File.symlink(old_name, new_name)
  end
  
  def directory?(dir)
    File.directory?(dir)
  end
  
  def exists?(dir, filename = "")    
    File.exists?(dir + file_separator + filename)
  end
  
  def lock(dir, &block)
    # io locking uses blocking call.
    # For example, when a player starts-coding then
    # the controller needs to wait to acquire a lock on
    # the dojo folder before choosing an avatar.    
    result = nil
    File.open(dir + file_separator + 'f.lock', "w") do |fd|
      if fd.flock(File::LOCK_EX)
        begin
          result = block.call()
        ensure
          fd.flock(File::LOCK_UN)
        end
      end
    end
    result
  end

private

  def make_dir(dir)
    if dir[-1] != '/'
      dir = File.dirname(dir)
    end
    # the -p option creates intermediate dirs as required
    command = "mkdir -p #{dir}"
    system(command)
  end  
  
end
