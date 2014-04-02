
class StubRunner

  def initialize
    @log = [ ]
  end

  def run(paas, sandbox, command, max_duration)
    path = paas.path(sandbox)
    @log << ("cd '#{path}';" + command)
    'stubbed-output'
  end

  def log
    @log
  end

end
