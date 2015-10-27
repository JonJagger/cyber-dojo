
# Ensures multiple threads all use the same test object.

class RailsRunnerStubThreadAdapter

  def initialize(caches)
    @caches = caches
  end

  def self.reset
    @@adaptee = nil
  end

  def method_missing(sym, *args, &block)
    @@adaptee ||= RunnerStub.new(@caches)
    @@adaptee.send(sym, *args, &block)
  end

end
