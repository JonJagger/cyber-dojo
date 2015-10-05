
# Ensures multiple threads all use the same test object.

class RailsDiskFakeThreadAdapter

  def self.reset
    @@adaptee = nil
  end

  def method_missing(sym, *args, &block)
    @@adaptee ||= DiskFake.new
    @@adaptee.send(sym, *args, &block)
  end

end
