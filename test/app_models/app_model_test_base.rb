
require_relative '../test_coverage'
require_relative '../all'
require_relative '../test_base'

class AppModelTestBase < TestBase

  include UniqueId

  def setup
    super
    `rm -rf #{tmp_root}/*`
    `rm -rf #{tmp_root}/.git`
    `mkdir -p #{tmp_root}/katas`
    `mkdir -p #{tmp_root}/caches`
    set_katas_root(tmp_root + 'katas')
    set_caches_root(tmp_root + 'caches')
    set_one_self_class('OneSelfDummy')
    set_runner_class   'RunnerStub'
    set_disk_class     'HostDisk'
    set_git_class      'HostGit'
  end

  def teardown
    super
  end

  def correct_path_format?(object)
    path = object.path
    ends_in_slash = path.end_with?('/')
    has_doubled_separator = path.scan('/' * 2).length != 0
    ends_in_slash && !has_doubled_separator
  end

end
