require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

# > ruby test/functional/initial_file_set_tests.rb

class InitialFileSetTests < ActionController::TestCase

  Root_test_folder = RAILS_ROOT + '/test/katas'

  def root_test_folder_reset
    system("rm -rf #{Root_test_folder}")
    Dir.mkdir Root_test_folder
  end

  def filesets_root_dir
    RAILS_ROOT +  '/filesets'
  end

  def katas_root_dir
    RAILS_ROOT +  '/katas'
  end
 
  def exercise
    'Yahtzee'
  end
  
  def name
    'Bertie-Bassett'
  end
  
  def browser
    'Firefox'
  end  
  
  def make_fileset(language)
    params = {
      :katas_root_dir => katas_root_dir,
      :filesets_root_dir => filesets_root_dir,
      :browser => browser,
      'language' => language,
      'exercise' => 'Yahtzee',
      'name' => name
    }
    InitialFileSet.new(params)
  end
  
  def test_copy_hidden_files_to_target_folder  
    root_test_folder_reset
    sandbox = Root_test_folder + '/sandbox'
    Dir::mkdir(sandbox)
    fileset = make_fileset('Java')
    fileset.copy_hidden_files_to(sandbox)
    assert File.exists?(sandbox + '/junit-4.7.jar'), 'junit-4.7.jar file created'
  end
  
  def test_copy_hidden_files_to_target_folder_does_nothing_beningly_if_no_hidden_files
    root_test_folder_reset
    sandbox = Root_test_folder + '/sandbox'
    Dir::mkdir(sandbox)
    fileset = make_fileset('C++')    
    fileset.copy_hidden_files_to(sandbox)
  end
  
  def test_language_visible_files_plus_output_plus_instructions
    fileset = make_fileset('Java')    
    visible_files = fileset.visible_files
    assert visible_files['UntitledTest.java'].start_with? "\nimport org.junit.*;"
    assert_equal '', visible_files['output']
    assert visible_files['instructions'].start_with? "The game of yahtzee"
  end

  def test_tab_defaults_to_4
    fileset = make_fileset('Java')    
    assert_equal 4, fileset.tab_size
  end
  
  def test_tab_when_not_defaulted
    fileset = make_fileset('Ruby')    
    assert_equal 2, fileset.tab_size
  end
  
  def test_unit_test_framework
    fileset = make_fileset('Ruby')    
    assert_equal 'ruby_test_unit', fileset.unit_test_framework
  end

  def test_language
    fileset = make_fileset('Ruby')        
    assert_equal 'Ruby', fileset.language
  end
  
  def test_exercise
    fileset = make_fileset('Ruby')        
    assert_equal exercise, fileset.exercise
  end
  
  def test_name
    fileset = make_fileset('Ruby')        
    assert_equal name, fileset.name
  end
  
  def test_browser
    fileset = make_fileset('Ruby')
    assert_equal browser, fileset.browser
  end
  
  def test_kata_root_dir
    fileset = make_fileset('Ruby')
    assert_equal katas_root_dir, fileset.katas_root_dir
  end
  
end
