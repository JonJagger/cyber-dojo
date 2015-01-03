
require_relative '../test_coverage'
require_relative '../all'
require 'test/unit'

class IntegrationTestBase < Test::Unit::TestCase

  def setup
    thread[:disk  ] = Disk.new
    thread[:git   ] = Git.new
    thread[:runner] = HostTestRunner.new
    thread[:exercises_path] = root_path + 'exercises/'
    thread[:languages_path] = root_path + 'languages/'
    thread[:katas_path]     = root_path + 'test/cyberdojo/katas/'
    @dojo = Dojo.new
    `rm -rf #{@dojo.katas.path}*`
  end

  def make_kata(dojo, language_name, exercise_name = 'Fizz_Buzz')
    language = dojo.languages[language_name]
    exercise = dojo.exercises[exercise_name]
    dojo.katas.create_kata(language, exercise)
  end

  def self.test(name, &block)
    define_method("test_#{name}".to_sym, &block)
  end

  def thread
    Thread.current
  end

private

  def root_path
    File.expand_path('../..', File.dirname(__FILE__)) + '/'
  end

end
