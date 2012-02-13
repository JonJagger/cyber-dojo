require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

# > ruby test/functional/language_file_set_tests.rb

class LanguageFileSetTests < ActionController::TestCase

  Root_test_folder = RAILS_ROOT + '/test/test_dojos'

  def root_test_folder_reset
    system("rm -rf #{Root_test_folder}")
    Dir.mkdir Root_test_folder
  end

  def filesets_root
    RAILS_ROOT +  '/filesets'
  end
  
  def test_copy_hidden_files_to_target_folder  
    root_test_folder_reset
    sandbox = Root_test_folder + '/sandbox'
    Dir::mkdir(sandbox)
    fileset = LanguageFileSet.new(filesets_root + '/language/Java')
    fileset.copy_hidden_files_to(sandbox)
    assert File.exists?(sandbox + '/junit-4.7.jar'), 'junit-4.7.jar file created'
  end
  
  def test_copy_hidden_files_to_target_folder_does_nothing_beningly_if_no_hidden_files
    root_test_folder_reset
    sandbox = Root_test_folder + '/sandbox'
    Dir::mkdir(sandbox)
    fileset = LanguageFileSet.new(filesets_root + '/language/C++')
    fileset.copy_hidden_files_to(sandbox)
  end
  
  def test_read_visible_files
    fileset = LanguageFileSet.new(filesets_root + '/language/Java')
    visible_files = fileset.visible_files
    code = visible_files['UntitledTest.java']
    assert code != nil
    assert code.start_with? "\nimport org.junit.*;"
  end

  def test_tab_default
    fileset = LanguageFileSet.new(filesets_root + '/language/Java')
    assert_equal 4, fileset.tab_size
  end
  
  def test_tab_not_default
    fileset = LanguageFileSet.new(filesets_root + '/language/Ruby')
    assert_equal 2, fileset.tab_size
  end
  
  def test_unit_test_framework
    fileset = LanguageFileSet.new(filesets_root + '/language/Ruby')
    assert_equal 'ruby_test_unit', fileset.unit_test_framework
  end

end
