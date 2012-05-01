ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'make_time_helper'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  include MakeTimeHelper
  
  def make_info( language_name, exercise_name = 'Yahtzee', id = Uuid.gen, now = make_time(Time.now) )
    language = Language.new(root_dir, language_name)
    exercise = Exercise.new(root_dir, exercise_name)
    { 
      :created => now,
      :id => id,
      :browser => 'Firefox',
      :language => language.name,
      :exercise => exercise.name,
      :visible_files => language.visible_files,
      :unit_test_framework => language.unit_test_framework,
      :tab_size => language.tab_size
    }
  end
  
  def make_kata(language_name, exercise_name = 'Yahtzee')
    info = make_info(language_name, exercise_name)
    Kata.create_new(root_dir, info)
    Kata.new(root_dir, info[:id])
  end
    
  def run_tests(avatar, visible_files)
    language = avatar.kata.language
    sandbox = Sandbox.new(root_dir)
    sandbox.test_timeout = 1
    output = sandbox.run(language, visible_files)
    inc = CodeOutputParser::parse(language.unit_test_framework, output)
    avatar.save_run_tests(visible_files, output, inc)
    output
  end

  def root_dir
    (@root_dir || Rails.root + 'test/cyberdojo').to_s
  end
  
  def teardown
    system("rm -rf #{root_dir}/katas/*")
  end
  
end
