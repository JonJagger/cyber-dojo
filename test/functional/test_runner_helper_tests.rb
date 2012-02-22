require File.dirname(__FILE__) + '/../test_helper'
require 'test_runner_helper'

# > ruby test/functional/test_runner_helper_tests.rb

class TestRunnerHelperTests < ActionController::TestCase

  include TestRunnerHelper

  ROOT_TEST_DIR = RAILS_ROOT + '/test/katas'

  def root_test_dir_reset
    system("rm -rf #{ROOT_TEST_DIR}")
    Dir.mkdir ROOT_TEST_DIR
  end

  def make_params(language)
    params = {
      :katas_root_dir => ROOT_TEST_DIR,
      :filesets_root_dir => RAILS_ROOT +  '/filesets',
      :browser => 'Firefox',
      'language' => language,
      'exercise' => 'Yahtzee',
      'name' => 'Valentine'
    }
  end

  def make_kata(language)
    params = make_params(language)
    fileset = InitialFileSet.new(params)
    info = Kata::create_new(fileset)
    params[:id] = info[:id]
    Kata.new(params)    
  end

  def test_recreate_new_sandbox
    root_test_dir_reset
    kata = make_kata('Java JUnit')
    avatar = Avatar.new(kata, 'frog')
    recreate_new(avatar.sandbox)
    assert_equal true, File.exists?(avatar.sandbox), "sandbox created"
    assert_equal true, File.exists?(avatar.sandbox + '/junit-4.7.jar'), "linked hidden file created"
  end    

  def test_makefile_filter_when_filename_not_makefile
     name     = 'not_makefile'
     content  = "    abc"
     actual   = makefile_filter(name, content)
     expected = "    abc"
     assert_equal expected, actual
  end

  def test_makefile_filter_when_filename_is_makefile
     name     = 'makefile'
     content  = "    abc"
     actual   = makefile_filter(name, content)
     expected = "\tabc"
     assert_equal expected, actual
  end

  def test_makefile_filter_when_filename_is_Makefile_with_uppercase_M
     name     = 'Makefile'
     content  = "    abc"
     actual   = makefile_filter(name, content)
     expected = "\tabc"
     assert_equal expected, actual
  end
      
end

