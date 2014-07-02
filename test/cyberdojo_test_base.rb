
require_relative 'test_coverage'
require_relative 'all'
require 'test/unit'

class CyberDojoTestBase < Test::Unit::TestCase

  include MakeTimeHelper

  def setup
    `rm -rf #{root_path}/katas/*`
  end

  def make_kata(dojo, language_name, exercise_name = 'test_Yahtzee')
    language = dojo.languages[language_name]
    exercise = dojo.exercises[exercise_name]
    dojo.katas.create_kata(language, exercise)
  end

  def make_manifest(dojo, language_name, exercise_name)
    language = dojo.languages[language_name]
    {
      :created => now = make_time(Time.now),
      :id => Id.new.to_s,
      :language => language.name,
      :exercise => exercise_name,
      :visible_files => language.visible_files,
      :unit_test_framework => language.unit_test_framework,
      :tab_size => language.tab_size
    }
  end

  def run_test(delta, avatar, visible_files, timeout = 15)
    now = make_time(Time.now)
    lights = avatar.test(delta, visible_files, timeout, now)
    avatar.save_manifest(visible_files)
    avatar.commit(lights.length)
    visible_files['output']
  end

  def root_path
    cyberdojo_home_dir = File.expand_path('..', File.dirname(__FILE__))
    (cyberdojo_home_dir + '/test/cyberdojo/').to_s
  end

  def self.test(name, &block)
    define_method("test_#{name}".to_sym, &block)
  end

end
