
module Externals

  def disk
    thread[:disk] ||= OsDisk.new
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
    keys.each { |key|
      raise RuntimeError.new("unknown " + key.to_s) unless
        [:disk,:git, :runner].include?(key)
    }
    keys.each { |key|
      raise RuntimeError.new("no external " + key.to_s) if
        thread[key].nil? }
  end

end
