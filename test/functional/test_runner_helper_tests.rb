require File.dirname(__FILE__) + '/../test_helper'
require 'test_runner_helper'

# > ruby test/functional/test_runner_helper_tests.rb

class TestRunnerHelperTests < ActionController::TestCase

  include TestRunnerHelper

  Root_test_folder = RAILS_ROOT + '/test/test_dojos'

  def root_test_folder_reset
    system("rm -rf #{Root_test_folder}")
    Dir.mkdir Root_test_folder
  end

  def make_params_name(language)
    { :dojo_name => language, 
      :dojo_root => Root_test_folder,
      :filesets_root => RAILS_ROOT + '/filesets',
      'language' => language,
      'kata' => 'Prime Factors',
      :browser => 'None (test)'
    }
  end

  def test_recreate_new_sandbox
    root_test_folder_reset
    params = make_params_name('Java')
    assert Dojo::create(params)
    assert Dojo::configure(params)
    dojo = Dojo.new(params)
    avatar = Avatar.new(dojo, 'frog')
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

