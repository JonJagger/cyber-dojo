
module ExternalsSetter # mixin

  def set_external(symbol, object)
    Thread.current[symbol] ||= object
  end

  def reset_external(symbol, object)
    Thread.current[symbol] = object
  end

  def disk=(obj)
    p "disk=(obj)"
    @disk = threaded(:disk,obj)
  end

  def git=(obj)
    @git = threaded(:git,obj)
  end

  def runner=(obj)
    @runner = threaded(:runner,obj)
  end

  def exercises_path=(path)
    threaded(:exercises_path,path)
  end

  def languages_path=(path)
    threaded(:languages_path,path)
  end

  def katas_path=(path)
    threaded(:katas_path,path)
  end

private

  def threaded(symbol,obj)
    Thread.current[symbol] ||= obj
  end

end
