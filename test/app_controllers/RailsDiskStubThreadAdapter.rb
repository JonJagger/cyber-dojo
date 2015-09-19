
# Ensures multiple threads all use the same test object.

class RailsDiskStubThreadAdapter

  def self.reset
    @@adaptee = nil
  end

  def method_missing(sym, *args, &block)
    @@adaptee ||= DiskStub.new
    @@adaptee.send(sym, *args, &block)
  end

end
