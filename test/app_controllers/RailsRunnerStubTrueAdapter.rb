
class RailsRunnerStubTrueAdapter

  def method_missing(sym, *args, &block)
    @@adaptee ||= RunnerStubTrue.new
    @@adaptee.send(sym, *args, &block)
  end

  def self.reset
    @@adaptee = nil
  end

end
