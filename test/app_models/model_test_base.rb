
require_relative '../test_coverage'
require_relative '../all'
require_relative '../test_base'

class ModelTestBase < TestBase

  include UniqueId

  def setup
    super    
    set_runner_class_name   'RunnerStub'
    set_disk_class_name     'DiskStub' # TODO?: DiskFake would be faster...
    set_git_class_name      'GitSpy'
    set_one_self_class_name 'OneSelfDummy'
  end

  def teardown
    super
  end
  
  def path_ends_in_slash?(object)
    object.path.end_with?('/')
  end

  def path_has_no_adjacent_separators?(object)
    doubled_separator = '/' * 2
    object.path.scan(doubled_separator).length === 0
  end
  
end
