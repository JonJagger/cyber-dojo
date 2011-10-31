module Locking

  # Note: fd.flock() is not available on Windows
  
  def io_lock(path, &block)
    result = nil
    File.open(path, 'r') do |fd|
      if fd.flock(File::LOCK_EX | File::LOCK_NB)
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