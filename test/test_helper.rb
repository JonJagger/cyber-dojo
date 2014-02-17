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
  add_group 'app/lib',         'app/lib'
  add_group 'integration',     'integration' # hack
  
  add_group 'lib'             do |src_file|
    src_file.filename.include?('lib') &&
    !src_file.filename.include?('app/lib')
  end
  
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
  
  def setup
    root_dir = (@root_dir || Rails.root + 'test/cyberdojo').to_s
    system("rm -rf #{root_dir}/katas/*")
    @dojo = Dojo.new(root_dir)
  end
  
  def dojo_id
    @dojo_id || Uuid.new.to_s
  end
  
  def make_info(language_name, exercise_name = 'Yahtzee', id = dojo_id, now = make_time(Time.now) )
    @dojo_id = id
    language = @dojo.language(language_name)
    exercise = @dojo.exercise(exercise_name)
    { 
      :created => now,
      :id => id,
      :language => language.name,
      :exercise => exercise.name,
      :visible_files => language.visible_files,
      :unit_test_framework => language.unit_test_framework,
      :tab_size => language.tab_size
    }
  end
  
  def make_kata(language_name, exercise_name = 'Yahtzee', id = dojo_id)
    info = make_info(language_name, exercise_name, id)
    info[:visible_files]['output'] = ''
    info[:visible_files]['instructions'] = 'practice'    
    @dojo.create_kata(info)
  end
    
  def run_test(delta, avatar, visible_files, timeout = 15)
    output = avatar.sandbox.test(delta, visible_files, timeout)
    language = avatar.kata.language
    traffic_light = CodeOutputParser::parse(language.unit_test_framework, output)
    avatar.save_run_tests(visible_files, traffic_light)    
    output
  end
    
end
