
require_relative '../test_coverage'
require_relative '../all'
require_relative '../test_base'

class AppModelTestBase < TestBase

  include UniqueId

  def setup
    super
    set_runner_class   'RunnerStub'
    set_disk_class     'DiskStub'      # DiskFake would be faster but lots of tests
    set_git_class      'GitSpy'        # fail because they don't Stub specific files.
    set_one_self_class 'OneSelfDummy'
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
