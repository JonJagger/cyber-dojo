module Locking

  # Note: fd.flock() is not available on Windows
  
  # io locking uses non-blocking call.
  # If I used blocking and there was a problem then the thread
  # could get blocked indefinitely. Better to surface the problem.
  
  def io_lock(path, &block)
    result = nil
    File.open(path, 'r') do |fd|
      mode = File::LOCK_EX | File::LOCK_NB
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