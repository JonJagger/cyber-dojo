module Locking

  # io locking uses non-blocking call and currently
  # everything calls io_lock to lock. This is not right.
  # For example, when a player is start-coding then
  # the controller needs to wait to acquire a lock on
  # the dojo folder before choosing an avatar.
  
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