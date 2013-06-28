
require 'Files'

class DiskFile

  def separator
    File::SEPARATOR
  end
  
  def write(dir, filename, object)
    #TODO: move the implementation of Files::file_write to here
    Files::file_write(dir, filename, object)
  end
  
  def read(dir, filename)
    Files::file_read(dir, filename)
  end
  
  def symlink(old_name, new_name)
   File.symlink(old_name, new_name)
  end
  
  def directory?(dir)
    File.directory?(dir)
  end
  
  def exists?(dir, filename = "")    
    File.exists?(dir + separator + filename)
  end
  
  def lock(dir, &block)
    # io locking uses blocking call.
    # For example, when a player is start-coding then
    # the controller needs to wait to acquire a lock on
    # the dojo folder before choosing an avatar.    
    # See test/lib/io_lock_tests.rb
    result = nil
    File.open(dir, 'r') do |fd|
      mode = File::LOCK_EX
      if fd.flock(mode)
        begin
          result = block.call(fd)
        ensure
          fd.flock(File::LOCK_UN)
        end
      end
    end
    result
  end
  
end
