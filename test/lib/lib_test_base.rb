
root = './..'

require_relative root + '/test_coverage'
require_relative root + '/all'
require_relative root + '/test_base'

class LibTestBase < TestBase

  def setup
    super
    `rm -rf #{tmp_root}/*`
    `rm -rf #{tmp_root}/.git`
    `mkdir -p #{tmp_root}`
  end

  def teardown
    super
  end

end
