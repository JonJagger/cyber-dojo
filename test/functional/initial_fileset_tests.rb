require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

# > ruby test/functional/initial_fileset_tests.rb


class InitialFileSet
  
  def initialize(manifest_pathname)
    @manifest = eval IO.read(manifest_pathname)
    @dir = File.dirname(manifest_pathname)
  end
  
  def copy_hidden_files_to(folder)
    @manifest[:hidden_filenames].each do |hidden_filename|
      system("ln #{@dir}/#{hidden_filename} #{folder}/#{hidden_filename}")
    end
  end
  
  def visible_files
    result = { }
    @manifest[:visible_filenames].each do |visible_filename|
      result[visible_filename] = IO.read("#{@dir}/#{visible_filename}")
    end
    result
  end
end

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
