
module Externals # mixin

  def dir
    disk[path]
  end

  def disk
    raise RuntimeError.new("thread[:disk].nil?") if thread[:disk].nil?
    thread[:disk]
  end

  def git
    raise RuntimeError.new("thread[:git].nil?") if thread[:git].nil?
    thread[:git]
  end

  def runner
    raise RuntimeError.new("thread[:runner].nil?") if thread[:runner].nil?
    thread[:runner]
  end

  def thread
    Thread.current
  end

end
