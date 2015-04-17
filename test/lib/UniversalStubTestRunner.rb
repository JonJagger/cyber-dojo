
class UniversalStubTestRunner

  def run(sandbox, command, max_duration)
    if @output.nil?
      raise RuntimeError.new("StubTestRunner.run()) called unexpectedly")
    end
    @output
  end

  def runnable?(language)
    true
  end

end
