
require_relative '../test_coverage'
require_relative '../all'
require_relative '../test_base'

class AppModelTestBase < TestBase

  include UniqueId

  def self.tmp_key
    'CYBER_DOJO_TMP_ROOT'
  end

  def self.tmp_root
    root = ENV[tmp_key]
    fail RuntimeError.new("ENV['#{tmp_key}'] not exported") if root.nil?
    root.end_with?('/') ? root : (root + '/')
  end

  FileUtils.mkdir_p(tmp_root)
  fail RuntimeError.new("#{tmp_root} does not exist") unless File.directory?(tmp_root)

  def setup
    super
    tmp_root = self.class.tmp_root
    `rm -rf #{tmp_root}/*`
    `rm -rf #{tmp_root}/.git`
    `mkdir -p #{tmp_root}`
    set_katas_root(tmp_root + 'katas')
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

  def dir_of(object)
    disk[object.path]
  end

end
