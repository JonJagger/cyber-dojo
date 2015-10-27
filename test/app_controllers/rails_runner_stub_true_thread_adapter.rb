
# Ensures multiple threads all use the same test object.

class RailsRunnerStubTrueThreadAdapter

  def initialize(caches)
    @caches = caches
  end

  def self.reset
    @@adaptee = nil
  end

  def method_missing(sym, *args, &block)
    @@adaptee ||= RunnerStubTrue.new(@caches)
    @@adaptee.send(sym, *args, &block)
  end

end
