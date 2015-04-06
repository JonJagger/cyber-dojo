
require_relative '../test_coverage'
require_relative '../all'
require_relative '../test_base'

class ModelTestBase < TestBase

  include UniqueId

  def setup
    super    
    if disk_class_name === 'Disk'
      `rm -rf #{katas_root}*`
    end
  end

  def teardown
    super
  end
  
  def make_kata(id = unique_id, language_name = 'C-assert', exercise_name = 'Fizz_Buzz')
    language = dojo.languages[language_name]
    exercise = dojo.exercises[exercise_name]
    dojo.katas.create_kata(language, exercise, id)
  end

  def path_ends_in_slash?(object)
    object.path.end_with?('/')
  end

  def path_has_no_adjacent_separators?(object)
    doubled_separator = '/' * 2
    object.path.scan(doubled_separator).length === 0
  end
  
end
