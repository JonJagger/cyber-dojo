require 'simplecov'

module SimpleCov::Configuration
  def clean_filters
    @filters = [ ]
  end
end

SimpleCov.start do
  add_filter "/ruby-1.9.3-p125/"
  add_filter "/cyberdojo/config/"

  add_group 'app/controllers', 'app/controllers'
  add_group 'app/models'      do |src_file|
      # for some reason SimpleCov is seeing
      # cyberdojo/app/models/Dojo.rb and
      # cyberdojo/app/models/dojo.rb
      # when the later file does not exist!
      src_file.filename.include?('cyberdojo/app/models') &&
      !src_file.filename.include?('dojo.rb')
  end
  add_group 'app/helpers',     'app/helpers'
  add_group 'app/lib',         'app/lib'
  add_group 'integration',     'integration'
  add_group 'lib'             do |src_file|
    src_file.filename.include?('lib') &&
    !src_file.filename.include?('app/lib')
  end

end

SimpleCov.root '/Users/jonjagger/Desktop/Repos/cyberdojo'

me = File.expand_path(File.dirname(__FILE__))
$CYBERDOJO_HOME_DIR = File.expand_path('..', me) + '/'

$LOAD_PATH << $CYBERDOJO_HOME_DIR + 'lib'
$LOAD_PATH << $CYBERDOJO_HOME_DIR + 'app/helpers'
$LOAD_PATH << $CYBERDOJO_HOME_DIR + 'app/lib'
$LOAD_PATH << $CYBERDOJO_HOME_DIR + 'app/models'

require 'make_time_helper'
require 'test/unit'

class CyberDojoTestBase < Test::Unit::TestCase

  include MakeTimeHelper

  def setup
    system("rm -rf #{root_path}/katas/*")
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
    avatar.save(delta, visible_files)
    output = avatar.test(timeout)
    avatar.sandbox.write('output', output)
    avatar.save_visible_files(visible_files)
    traffic_light = OutputParser::parse(avatar.kata.language.unit_test_framework, output)
    traffic_lights = avatar.save_traffic_light(traffic_light, make_time(Time.now))
    avatar.commit(traffic_lights.length)
    output
  end

  def root_path
    ($CYBERDOJO_HOME_DIR + 'test/cyberdojo/').to_s
  end

  def self.test(name, &block)
      define_method("test_#{name}".to_sym, &block)
  end

end
