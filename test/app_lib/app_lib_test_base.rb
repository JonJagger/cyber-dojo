
require_relative '../test_coverage'
require_relative '../all'
require_relative '../test_base'

class AppLibTestBase < TestBase

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
  end

  def teardown
    super
  end

end
