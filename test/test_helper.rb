ENV['RAILS_ENV'] = 'test'

root = '..'

require_relative root + '/test/test_coverage'
require_relative root + '/config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase

  fixtures :all

  def root_path
    (Rails.root + 'test/cyberdojo/').to_s
  end

  def setup
    `rm -rf #{root_path}/katas/*`
  end

  def make_kata(dojo, language_name, exercise_name = 'test_Yahtzee')
    language = dojo.languages[language_name]
    exercise = dojo.exercises[exercise_name]
    dojo.katas.create_kata(language, exercise)
  end

end
