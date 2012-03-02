require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

# > ruby test/functional/initial_file_set_tests.rb

class InitialFileSetTests < ActionController::TestCase

  test "language visible files plus output plus instructions" do
    fileset = make_fileset('Dummy')    
    visible_files = fileset.visible_files
    assert visible_files['test_untitled.rb'].start_with? "require 'untitled'"
    assert_equal '', visible_files['output']
    assert visible_files['instructions'].start_with? "The game of Yahtzee..."
  end

  test "tab defaults to 4" do
    fileset = make_fileset('C assert')    
    assert_equal 4, fileset.tab_size
  end
  
  test "tab when not defaulted" do
    fileset = make_fileset('Dummy')    
    assert_equal 2, fileset.tab_size
  end
  
  test "unit test framework" do
    fileset = make_fileset('C assert')    
    assert_equal 'cassert', fileset.unit_test_framework
  end

  test "language" do
    fileset = make_fileset('C assert')        
    assert_equal 'C assert', fileset.language
  end
  
  test "exercise" do
    fileset = make_fileset('C assert')        
    assert_equal 'Yahtzee', fileset.exercise
  end
  
  test "name" do
    fileset = make_fileset('C assert')        
    assert_equal 'Jon Jagger', fileset.name
  end
  
  test "browser" do
    fileset = make_fileset('C assert')
    assert_equal 'Firefox', fileset.browser
  end
  
  def make_fileset(language)
    InitialFileSet.new(make_params(language))
  end
    
end
