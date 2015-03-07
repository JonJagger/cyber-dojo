
require_relative '../test_coverage'
require_relative '../all'
require_relative '../test_base'

class IntegrationTestBase < TestBase

  include ExternalSetter
  
  def setup
    reset_external(:disk, Disk.new)
    reset_external(:git, Git.new)
    reset_external(:runner, HostTestRunner.new)
    reset_external(:exercises_path, root_path + 'exercises/')
    reset_external(:languages_path, root_path + 'languages/')
    reset_external(:katas_path, root_path + 'test/cyber-dojo/katas/')    
    @dojo = Dojo.new
  end

  def make_kata(dojo, language_name, exercise_name = 'Fizz_Buzz')
    language = dojo.languages[language_name]
    exercise = dojo.exercises[exercise_name]
    dojo.katas.create_kata(language, exercise)
  end

private

  def root_path
    File.expand_path('../..', File.dirname(__FILE__)) + '/'
  end

end
