
class TestRunnerStub

  def initialize
    @log = [ ]
  end

  attr_reader :log

  def runnable?(language)
    true
  end

  def run(sandbox, command, max_duration)
    @log << ("cd '#{sandbox.path}';" + command)
    'stubbed-output'
  end

end
