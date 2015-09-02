
class RunnerStub

  def stub_output(stub)
    @output = stub
  end

  def stub_runnable(stub)
    @runnable = stub
  end
  
  def run(sandbox, command, max_duration)
    if @output.nil?
      raise RuntimeError.new("RunnerStub.run()) called unexpectedly")
    end
    @output
  end

  def runnable?(language)
    if @runnable.nil?      
      raise RuntimeError.new("RunnerStub.runnable? called unexpectedly")
    end
    @runnable
  end

  def started(avatar); end

end
