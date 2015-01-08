
module Externals # mixin

  def dir
    disk[path]
  end

  def disk
    threaded(:disk)
  end

  def git
    threaded(:git)
  end

  def runner
    threaded(:runner)
  end

  def exercises_path
    threaded(:exercises_path)
  end

  def languages_path
    threaded(:languages_path)
  end

  def katas_path
    threaded(:katas_path)
  end

  def thread
    Thread.current
  end

private

  def threaded(symbol)
    raise RuntimeError.new("thread[:" + symbol.to_s + "].nil?") if thread[symbol].nil?
    thread[symbol]
  end

end
