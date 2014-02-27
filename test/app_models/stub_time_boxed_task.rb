
class StubTimeBoxedTask

  def initialize
    @log = [ ]
  end

  def execute(command, max_run_tests_duration)
    @log << command
    "stubbed-output"
  end

  def log
    @log
  end

end
