
module Externals

  def runner
    thread[:runner]
  end

  def git
    thread[:git]
  end
  
  def disk
    thread[:disk]
  end

  def dir(path)
    disk[path]
  end

private

  def thread
    Thread.current
  end

end
