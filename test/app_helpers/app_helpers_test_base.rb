
require_relative '../test_coverage'
require_relative '../all'
require_relative '../test_base'

class AppHelpersTestBase < TestBase

  def setup
    super
    `rm -rf #{tmp_root}/katas`
    `rm -f #{tmp_root}/.git`
    `mkdir -p #{tmp_root}`
    set_katas_root(tmp_root + 'katas')
    set_one_self_class('OneSelfDummy')
    set_runner_class   'RunnerStub'
    set_disk_class     'HostDisk'
    set_git_class      'HostGit'
  end

end
