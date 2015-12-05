
class HostFileLocker

  def self.lock(filename, &block)
    result = nil
    File.open(filename, 'w') do |fd|
      if fd.flock(File::LOCK_EX)
        begin
          result = block.call
        ensure
          fd.flock(File::LOCK_UN)
        end
      end
    end
    result
  end

end
