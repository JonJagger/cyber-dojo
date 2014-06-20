
# mixin module

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

  def set_runner(arg)
    thread[:runner] = arg
  end

  def set_git(arg)
    thread[:git] ||= arg
  end

  def set_disk(arg)
    thread[:disk] = arg
  end

  def dir
    disk[path]
  end

private

  def thread
    Thread.current
  end

end
