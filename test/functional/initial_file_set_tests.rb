require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

# > ruby test/functional/initial_file_set_tests.rb

class InitialFileSetTests < ActionController::TestCase

  test "copy hidden files to target folder" do
    temp_dir = `uuidgen`.strip.delete('-')[0..9]
    sandbox_dir = TEST_ROOT_DIR + '/sandboxes/' + temp_dir
    
    fileset = make_fileset('Java JUnit')
    fileset.copy_hidden_files_to(sandbox_dir)
    assert File.exists?(sandbox + '/junit-4.7.jar'), 'junit-4.7.jar file created'
  end
  
  test "copy hidden files to target folder does nothing beningly if no hidden files" do
    temp_dir = `uuidgen`.strip.delete('-')[0..9]
    sandbox_dir = TEST_ROOT_DIR + '/sandboxes/' + temp_dir
    
    fileset = make_fileset('C++ Assert')    
    fileset.copy_hidden_files_to(sandbox_dir)
  end
  
  #TODO: capture sandbox_dir as a method  
  
  test "language visible files plus output plus instructions" do
    fileset = make_fileset('Java JUnit')    
    visible_files = fileset.visible_files
    assert visible_files['UntitledTest.java'].start_with? "\nimport org.junit.*;"
    assert_equal '', visible_files['output']
    assert visible_files['instructions'].start_with? "The game of yahtzee"
  end

  test "tab defaults to 4" do
    fileset = make_fileset('Java JUnit')    
    assert_equal 4, fileset.tab_size
  end
  
  test "tab when not defaulted" do
    fileset = make_fileset('Ruby')    
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
    fileset = make_fileset('Ruby')        
    assert_equal 'Jon Jagger', fileset.name
  end
  
  test "browser" do
    fileset = make_fileset('Ruby')
    assert_equal 'Firefox', fileset.browser
  end
  
  def make_fileset(language)
    InitialFileSet.new(make_params(language))
  end
    
end
