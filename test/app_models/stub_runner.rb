
class StubRunner

  def initialize
    @log = [ ]
  end

  def run(path, command, max_duration)
    @log << ("cd '#{path}';" + command)
    'stubbed-output'
  end

  def log
    @log
  end

end
