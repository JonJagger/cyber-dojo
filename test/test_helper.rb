ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

require 'make_time_helper'

class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.

  # self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.

  #self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting

  #fixtures :all

  # Add more helper methods to be used by all tests here...
  
  include MakeTimeHelper
  
  def make_info( language_name, exercise_name = 'Yahtzee', id = Uuid.gen, now = make_time(Time.now) )
    language = Language.new(root_dir, language_name)
    exercise = Exercise.new(root_dir, exercise_name)
    { 
      :name => 'Jon Jagger',
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
    language_name = avatar.kata.language
    language = Language.new(root_dir, language_name)
    sandbox = Sandbox.new(root_dir)
    output = sandbox.run(language, visible_files)
    inc = CodeOutputParser::parse(avatar.kata.unit_test_framework, output)
    avatar.save_run_tests(visible_files, output, inc)
    output
  end

  def root_dir
    @root_dir || RAILS_ROOT + '/test/cyberdojo'
  end
  
  def teardown
    system("rm -rf #{root_dir}/katas/*")
  end
  
end
