

module Locking

  # io locking uses blocking call.
  # For example, when a player is start-coding then
  # the controller needs to wait to acquire a lock on
  # the dojo folder before choosing an avatar.
  
  # See test/lib/io_lock_tests.rb
  
  def self.io_lock(path, &block)
    result = nil
    File.open(path, 'r') do |fd|
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