
module Externals

  def externals(runner = HostTestRunner.new,
                git    = Git.new,
                disk   = OsDisk.new)
    externals = {
      :disk   => disk,
      :git    => git,
      :runner => runner
    }
  end

end
