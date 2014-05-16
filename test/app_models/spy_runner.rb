
class SpyRunner

  def initialize
    @log = [ ]
  end

  def runnable?(language)
    true
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
