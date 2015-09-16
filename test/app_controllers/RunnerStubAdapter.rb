
# Ensures multiple threads all use the same RunnerStub object.
# Is there a way to coax rails into using a single thread?

class RunnerStubAdapter

  def method_missing(sym, *args, &block)
    @@runner ||= RunnerStub.new
    @@runner.send(sym, *args, &block)
  end

  def self.reset
    @@runner = nil
  end

end
