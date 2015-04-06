
class StubTestRunner

  def stub(output)
    @output = output
  end

  def run(sandbox, command, max_duration)
    @output
  end

  def runnable?(language)
    raise RuntimeError.new("StubTestRunner.runnable? called unexpectedly")
  end

end
