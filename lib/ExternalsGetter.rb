
module ExternalsGetter # mixin

  def dir
    disk[path]
  end

  def disk
    external(:disk)
  end

  def git
    external(:git)
  end

  def runner
    external(:runner)
  end

  def exercises_path
    external(:exercises_path)
  end

  def languages_path
    external(:languages_path)
  end

  def katas_path
    external(:katas_path)
  end

private

  def external(symbol)
    thread = Thread.current
    raise RuntimeError.new('no external(:' + symbol.to_s + ')') if thread[symbol].nil?
    thread[symbol]
  end

end
