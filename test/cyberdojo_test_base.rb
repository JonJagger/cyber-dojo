
require_relative 'test_coverage'
require_relative 'all'
require 'test/unit'

class CyberDojoTestBase < Test::Unit::TestCase

  def root_path
    File.expand_path('..', File.dirname(__FILE__)) + '/'
  end

  def setup
    ENV['CYBERDOJO_TEST_ROOT_DIR'] = 'true'
    `rm -rf #{root_path}test/cyberdojo/katas/*`
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
  
end
