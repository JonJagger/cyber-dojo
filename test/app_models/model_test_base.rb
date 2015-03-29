
require_relative '../test_coverage'
require_relative '../all'
require_relative '../test_base'

class ModelTestBase < TestBase

  include ExternalSetter
  include ExternalDiskDir
  include ExternalGit
  include ExternalRunner
  include ExternalExercisesPath
  include ExternalLanguagesPath
  include ExternalKatasPath
  include UniqueId

  def setup
    check_test_environment_setup
    @dojo = Dojo.new
    @max_duration = 15
  end

  def teardown
    restore_original_test_environment
  end
  
  def make_kata(id = unique_id)
    language = @dojo.languages['C-assert']
    exercise = @dojo.exercises['Fizz_Buzz']
    @dojo.katas.create_kata(language, exercise, id)
  end

  def path_ends_in_slash?(object)
    object.path.end_with?(disk.dir_separator)
  end

  def path_has_adjacent_separators?(object)
    doubled_separator = disk.dir_separator * 2
    object.path.scan(doubled_separator).length > 0
  end

private

  def check_test_environment_setup
    @test_env = { }
    assert exercises_path?, "exercises_path not set"
    @test_env['exercises_path'] = exercises_path
    assert disk?, "disk not set"
    @test_env['disk_class_name'] = disk_class_name
  end
  
  def restore_original_test_environment    
    set_exercises_path(@test_env['exercises_path']) if !@test_env['exercises_path'].nil?
    set_disk_class_name(@test_env['disk_class_name']) if !@test_env['disk_class_name'].nil?
  end
  
end
