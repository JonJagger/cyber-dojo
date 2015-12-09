
require_relative '../test_coverage'
require_relative '../all'
require_relative '../test_base'

class AppModelTestBase < TestBase

  include UniqueId

  def setup
    super
    set_katas_root(tmp_root + 'katas')
    set_one_self_class('OneSelfDummy')
    set_runner_class   'RunnerMock'
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
