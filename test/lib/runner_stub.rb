
class RunnerStub

  def initialize(_caches)
  end

  def stub_output(stub)
    @output = stub
  end

  def stub_runnable(stub)
    @runnable = stub
  end

  def run(_sandbox, _max_seconds)
    if @output.nil?
      raise RuntimeError.new("RunnerStub.run()) called unexpectedly")
    end
    @output
  end

  def runnable?(_language)
    if @runnable.nil?
      raise RuntimeError.new("RunnerStub.runnable? called unexpectedly")
    end
    @runnable
  end

end
