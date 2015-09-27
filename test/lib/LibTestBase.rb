
root = './..'

require_relative root + '/test_coverage'
require_relative root + '/all'
require_relative root + '/test_base'
require_relative root + '/TestExternalHelpers'

class LibTestBase < TestBase

  def self.tmp_key
    'CYBER_DOJO_TMP_ROOT'
  end

  def self.tmp_root
    root = ENV[tmp_key]
    root.end_with?('/') ? root : (root + '/')
  end

  fail RuntimeError.new("#ENV[#{tmp_key}] not set") if tmp_root.nil?
  FileUtils.mkdir_p(tmp_root)
  fail RuntimeError.new("#{tmp_root} does not exist") unless File.directory?(tmp_root)

  def setup
    store_env_vars
    tmp_root = self.class.tmp_root
    `rm -rf #{tmp_root}/*`
    `rm -rf #{tmp_root}/.git`
    `mkdir -p #{tmp_root}`
  end

end
