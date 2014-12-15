
module Externals

  def externals(runner = runner,
                git    = Git.new,
                disk   = OsDisk.new)
    {
      :disk   => disk,
      :git    => git,
      :runner => runner
    }
  end

  def runner
    if Docker.installed?
      DockerTestRunner.new
    else
      HostTestRunner.new
    end
  end

end
