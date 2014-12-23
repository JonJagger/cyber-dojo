
module Externals

  def set_externals
    thread[:disk] = OsDisk.new
    thread[:git] = Git.new
    thread[:runner] = runner
  end

  def runner
    if Docker.installed?
      DockerTestRunner.new
    else
      HostTestRunner.new
    end
  end

end
