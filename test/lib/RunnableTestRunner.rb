
class RunnableTestRunner

  def runnable?(language)
    true
  end

  def run(sandbox, command, max_duration)
    raise RuntimeError.new("RunnableTestRunner.run() called unexpectedly")
  end

end
