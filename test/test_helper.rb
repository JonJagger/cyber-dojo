ENV["RAILS_ENV"] = "test"
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
  add_group 'app/models',      'app/models'
  add_group 'app/helpers',     'app/helpers'
  add_group 'lib',             'lib'
  
end

SimpleCov.root '/Users/jonjagger/Desktop/Repos/cyberdojo'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'make_time_helper'
require 'Uuid'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  include MakeTimeHelper
  
  def dojo_id
    @dojo_id || Uuid.new.to_s
  end
  
  def make_info( language_name, exercise_name = 'Yahtzee', id = dojo_id, now = make_time(Time.now) )
    @dojo_id = id
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
  
  def make_kata(language_name, exercise_name = 'Yahtzee', id = dojo_id)
    info = make_info(language_name, exercise_name, id)
    Kata.create_new(root_dir, info)
    Kata.new(root_dir, info[:id])
  end
    
  def run_tests(avatar, visible_files, timeout = 15)
    language = avatar.kata.language
    sandbox = Sandbox.new(avatar)
    sandbox.test_timeout = timeout
    output = sandbox.run(language, visible_files)
    inc = CodeOutputParser::parse(language.unit_test_framework, output)
    avatar.save_run_tests(visible_files, output, inc)
    output
  end

  def root_dir
    #TODO?: use ENV like test/integration/integration_test.rb
    (@root_dir || Rails.root + 'test/cyberdojo').to_s
  end
  
  def teardown
    system("rm -rf #{root_dir}/katas/*")
    system("rm -rf #{root_dir}/zips/*")
  end
  
end
