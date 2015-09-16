
# Ensures multiple threads all use the same DiskFake object.
# Is there a way to coax rails into using a single thread?

class RailsDiskFakeAdapter

  def method_missing(sym, *args, &block)
    @@disk ||= DiskFake.new
    @@disk.send(sym, *args, &block)
  end

  def self.reset
    @@disk = nil
  end

end
