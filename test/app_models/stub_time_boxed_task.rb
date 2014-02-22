
class StubTimeBoxedTask

  def initialize
    @log = [ ]
  end

  def execute(command, max_run_tests_duration)
    @log << command
    "amber"
  end

  def log
    @log
  end

end
