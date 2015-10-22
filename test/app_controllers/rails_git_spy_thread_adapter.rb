
# Ensures multiple threads all use the same test object.

class RailsGitSpyThreadAdapter

  def self.reset
    @@adaptee = nil
  end

  def method_missing(sym, *args, &block)
    @@adaptee ||= GitSpy.new
    @@adaptee.send(sym, *args, &block)
  end

end
