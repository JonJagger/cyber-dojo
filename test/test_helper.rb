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

  fixtures :all
  include MakeTimeHelper
  
  def setup
    system("rm -rf #{root_dir}/katas/*")
    @dojo = dojo
  end
  
  def make_kata(language_name, exercise_name = 'Yahtzee')
    # does not rely on setup having been called.
    # See installation/one_language_checker::language_test()
    manifest = make_manifest(language_name, exercise_name)
    manifest[:visible_files]['output'] = ''
    manifest[:visible_files]['instructions'] = 'practice'    
    dojo.create_kata(manifest)
  end
    
  def run_test(delta, avatar, visible_files, timeout = 15)
    output = avatar.sandbox.test(delta, visible_files, timeout)
    language = avatar.kata.language
    traffic_light = CodeOutputParser::parse(language.unit_test_framework, output)
    avatar.save_run_tests(visible_files, traffic_light)    
    output
  end

private

  def root_dir
    (Rails.root + 'test/cyberdojo').to_s
  end
  
  def dojo
    Dojo.new(root_dir)
  end
  
  def make_manifest(language_name, exercise_name)
    language = dojo.language(language_name)
    { 
      :created => now = make_time(Time.now),
      :id => Uuid.new.to_s,
      :language => language.name,
      :exercise => exercise_name,
      :visible_files => language.visible_files,
      :unit_test_framework => language.unit_test_framework,
      :tab_size => language.tab_size
    }
  end

end
