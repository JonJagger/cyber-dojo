require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

# > ruby test/functional/avatar_tests.rb

class AvatarTests < ActionController::TestCase

  include Files
  extend Files
  
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
      'name' => 'Jon Jagger'
    }
  end

  def make_kata(language = 'Ruby') 
    params = make_params(language)
    fileset = InitialFileSet.new(params)
    info = Kata::create_new(fileset)
    params[:id] = info[:id]
    Kata.new(params)    
  end
  
  def test_no_increments_before_first_test_run
    root_test_dir_reset
    kata = make_kata
    avatar = Avatar.new(kata, 'wolf')    
    assert_equal [ ], avatar.increments    
  end
  
  def test_increments_does_not_contain_output
    root_test_dir_reset
    params = make_params('C Assert')
    fileset = InitialFileSet.new(params)
    info = Kata::create_new(fileset)
    params[:id] = info[:id]
    kata = Kata.new(params)    
    
    avatar = Avatar.new(kata, 'wolf')    
    avatar.run_tests(fileset.visible_files)
    increments = avatar.increments
    assert_equal 1, increments.length
    assert_equal nil, increments.last[:run_tests_output]
  end
  
end
