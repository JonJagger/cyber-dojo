
# mixin module

module Externals

  def disk
    thread[:disk]
  end

  def git
    thread[:git]
  end

  def runner
    thread[:runner]
  end

  def set_disk(arg)
    thread[:disk] ||= arg
  end

  def set_git(arg)
    thread[:git] ||= arg
  end

  def set_runner(arg)
    thread[:runner] ||= arg
  end

  def dir
    disk[path]
  end

  def reset
    thread[:disk] = nil
    thread[:git] = nil
    thread[:runner] = nil
  end

private

  def thread
    Thread.current
  end

end
