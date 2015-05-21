
class TestRunnerStub

  def initialize(dojo=nil)
  end
    
  def stub_output(stub)
    @output = stub
  end

  def stub_runnable(stub)
    @runnable = stub
  end
  
  def run(sandbox, command, max_duration)
    if @output.nil?
      raise RuntimeError.new("StubTestRunner.run()) called unexpectedly")
    end
    @output
  end

  def runnable?(language)
    if @runnable.nil?      
      raise RuntimeError.new("StubTestRunner.runnable? called unexpectedly")
    end
    @runnable
  end

end
