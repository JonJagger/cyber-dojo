ENV['RAILS_ENV'] = 'test'

root = '..'

require_relative root + '/test/test_coverage'
require_relative root + '/config/environment'
require_relative root + '/lib/TimeNow'
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

  #def make_manifest(dojo, language_name, exercise_name)
  #  language = dojo.languages[language_name]
  #  {
  #    :created => time_now,
  #    :id => Id.new.to_s,
  #    :language => language.name,
  #    :exercise => exercise_name,
  #    :visible_files => language.visible_files,
  #    :unit_test_framework => language.unit_test_framework,
  #    :tab_size => language.tab_size
  #  }
  #end

  def run_test(delta, avatar, visible_files, timeout = 15)
    lights = avatar.test(delta, visible_files, timeout, time_now)
    avatar.save_manifest(visible_files)
    avatar.commit(lights.length)
    visible_files['output']
  end

private

  include TimeNow

end
