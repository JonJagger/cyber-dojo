
module Externals # mixin

  def dir
    disk[path]
  end

  def disk
    thread[:disk] ||= Disk.new
  end

  def git
    thread[:git] ||= Git.new
  end

  def runner
    thread[:runner] ||= DockerTestRunner.new if Docker.installed?
    thread[:runner] ||= HostTestRunner.new unless ENV['CYBERDOJO_USE_HOST'].nil?
    thread[:runner] ||= DummyTestRunner.new
  end

  def thread
    Thread.current
  end

  def raise_if_no(keys)
    externals = [:disk,:git,:runner]
    keys.each { |key|
      raise error("unknown " + key.to_s) unless externals.include?(key)
    }
    keys.each { |key|
      raise error("no external " + key.to_s) if thread[key].nil?
    }
  end

  def error(message)
    RuntimeError.new(message)
  end

end
