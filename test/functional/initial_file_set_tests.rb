require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

# > ruby test/functional/initial_file_set_tests.rb

class InitialFileSetTests < ActionController::TestCase

  Root_test_folder = RAILS_ROOT + '/test/test_katas'

  def root_test_folder_reset
    system("rm -rf #{Root_test_folder}")
    Dir.mkdir Root_test_folder
  end

  def filesets_root
    RAILS_ROOT +  '/filesets'
  end
  
  def exercise
    'Yahtzee'
  end
  
  def test_copy_hidden_files_to_target_folder  
    root_test_folder_reset
    sandbox = Root_test_folder + '/sandbox'
    Dir::mkdir(sandbox)
    fileset = InitialFileSet.new(filesets_root, 'Java', exercise)
    fileset.copy_hidden_files_to(sandbox)
    assert File.exists?(sandbox + '/junit-4.7.jar'), 'junit-4.7.jar file created'
  end
  
  def test_copy_hidden_files_to_target_folder_does_nothing_beningly_if_no_hidden_files
    root_test_folder_reset
    sandbox = Root_test_folder + '/sandbox'
    Dir::mkdir(sandbox)
    fileset = InitialFileSet.new(filesets_root, 'C++', exercise)
    fileset.copy_hidden_files_to(sandbox)
  end
  
  def test_language_visible_files_plus_output_plus_instructions
    fileset = InitialFileSet.new(filesets_root, 'Java', exercise)
    visible_files = fileset.visible_files
    assert visible_files['UntitledTest.java'].start_with? "\nimport org.junit.*;"
    assert_equal '', visible_files['output']
    assert visible_files['instructions'].start_with? "The game of yahtzee"
  end

  def test_tab_defaults_to_4
    fileset = InitialFileSet.new(filesets_root, 'Java', exercise)
    assert_equal 4, fileset.tab_size
  end
  
  def test_tab_when_not_defaulted
    fileset = InitialFileSet.new(filesets_root, 'Ruby', exercise)
    assert_equal 2, fileset.tab_size
  end
  
  def test_unit_test_framework
    fileset = InitialFileSet.new(filesets_root, 'Ruby', exercise)
    assert_equal 'ruby_test_unit', fileset.unit_test_framework
  end

  def test_language
    fileset = InitialFileSet.new(filesets_root, 'Ruby', exercise)
    assert_equal 'Ruby', fileset.language
  end
  
  def test_exercise
    fileset = InitialFileSet.new(filesets_root, 'Ruby', exercise)
    assert_equal exercise, fileset.exercise
  end
  
end
