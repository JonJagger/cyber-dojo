ENV["RAILS_ENV"] = "test"

__DIR__ = File.dirname(__FILE__)
require __DIR__ + '/test_coverage'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'make_time_helper'

class ActiveSupport::TestCase

  fixtures :all
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
    visible_files['output'] = output
    avatar.save_manifest(visible_files)
    traffic_light = OutputParser::parse(avatar.kata.language.unit_test_framework, output)
    traffic_lights = avatar.save_traffic_light(traffic_light, make_time(Time.now))
    avatar.commit(traffic_lights.length)
    output
  end

  def root_path
    (Rails.root + 'test/cyberdojo/').to_s
  end

end
