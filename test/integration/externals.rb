
module Externals

  def set_externals
    thread[:disk] = OsDisk.new
    thread[:git] = Git.new
    thread[:runner] = runner
  end

  def runner
    return DockerTestRunner.new if Docker.installed?
    return HostTestRunner.new
  end

end
