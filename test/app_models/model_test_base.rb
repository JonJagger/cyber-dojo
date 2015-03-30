
require_relative '../test_coverage'
require_relative '../all'
require_relative '../test_base'

class ModelTestBase < TestBase

  include ExternalExercisesPath
  include ExternalLanguagesPath
  include ExternalKatasPath
  include ExternalDiskDir
  include ExternalRunner
  include ExternalGit
  include UniqueId

  def setup
    check_test_environment_setup
    @dojo = Dojo.new
    @max_duration = 15
    if disk_class_name === 'Disk'
      `rm -rf #{katas_path}*`
    end
  end

  def teardown
    restore_original_test_environment
  end
  
  def make_kata(id = unique_id, language_name = 'C-assert', exercise_name = 'Fizz_Buzz')
    language = @dojo.languages[language_name]
    exercise = @dojo.exercises[exercise_name]
    @dojo.katas.create_kata(language, exercise, id)
  end

  def path_ends_in_slash?(object)
    object.path.end_with?(disk.dir_separator)
  end

  def path_has_no_adjacent_separators?(object)
    doubled_separator = disk.dir_separator * 2
    object.path.scan(doubled_separator).length === 0
  end

private

  def check_test_environment_setup
    @test_env = { }
    assert exercises_path?, "exercises_path not set"
    @test_env['exercises_path'] = exercises_path
    assert languages_path?, "languages_path not set"
    @test_env['languages_path'] = languages_path
    assert katas_path?, "katas_path not set"
    @test_env['katas_path'] = katas_path
    assert disk?, "disk not set"
    @test_env['disk_class_name'] = disk_class_name
    assert runner?, "runner not set"
    @test_env['runner_class_name'] = runner_class_name
    assert git?, "git not set"
    @test_env['git_class_name'] = git_class_name
  end
  
  def restore_original_test_environment    
    restore('exercises_path')
    restore('languages_path')
    restore('katas_path')
    restore('disk_class_name')
    restore('runner_class_name')
    restore('git_class_name')
  end
  
  def restore(key)
    value = @test_env[key]
    send('set_' + key, value) if !value.nil?
  end
  
end
