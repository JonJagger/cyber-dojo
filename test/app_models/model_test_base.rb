
require_relative '../test_coverage'
require_relative '../all'
require_relative '../test_base'

class ModelTestBase < TestBase

  include UniqueId

  def setup
    super    
    set_runner_class_name('DummyTestRunner')        
    if get_disk_class_name === 'Disk'
      `rm -rf #{get_katas_root}*`
    end
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
