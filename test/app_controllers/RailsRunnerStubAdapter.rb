
class RailsRunnerStubAdapter

  def method_missing(sym, *args, &block)
    @@adaptee ||= RunnerStub.new
    @@adaptee.send(sym, *args, &block)
  end

  def self.reset
    @@adaptee = nil
  end

end
