
module Externals

  def runner
    thread[:runner]
  end

  def git
    thread[:git]
  end

  def dir(path)
    disk[path]
  end

private

  def disk
    thread[:disk]
  end

  def thread
    Thread.current
  end

end
