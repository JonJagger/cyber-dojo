require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

# > ruby test/functional/initial_fileset_tests.rb

class InitialFileSetTests < ActionController::TestCase

  Root_test_folder = RAILS_ROOT + '/test/test_dojos'

  def root_test_folder_reset
    system("rm -rf #{Root_test_folder}")
    Dir.mkdir Root_test_folder
  end

  def make_params
    { :filesets_root => RAILS_ROOT +  '/filesets',
      'language' => 'Java',
    }
  end
  
  def test_copy_hidden_files_to_target_folder  
    root_test_folder_reset
    params = make_params
    sandbox = Root_test_folder + '/sandbox'
    Dir::mkdir(sandbox)
    fileset = InitialFileSet.new(params[:filesets_root] + '/language/Java/manifest.rb')
    fileset.copy_hidden_files_to(sandbox)
    assert File.exists?(sandbox + '/junit-4.7.jar'), 'junit-4.7.jar file created'
  end
  
  def test_copy_hidden_files_to_target_folder_does_nothing_beningly_if_no_hidden_files
    root_test_folder_reset
    params = make_params
    sandbox = Root_test_folder + '/sandbox'
    Dir::mkdir(sandbox)
    fileset = InitialFileSet.new(params[:filesets_root] + '/language/C++/manifest.rb')
    fileset.copy_hidden_files_to(sandbox)
  end
  
  def test_read_visible_files
    root_test_folder_reset
    params = make_params
    sandbox = Root_test_folder + '/sandbox'
    Dir::mkdir(sandbox)
    fileset = InitialFileSet.new(params[:filesets_root] + '/language/Java/manifest.rb')
    visible_files = fileset.visible_files
    code = visible_files['UntitledTest.java']
    assert code != nil
    assert code.start_with? "\nimport org.junit.*;"
  end

end
