require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

# > ruby test/functional/new_kata_tests.rb

class NewKataTests < ActionController::TestCase

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
  
  def test_create_new_using_uuid
    root_test_dir_reset
    params = make_params('Java JUnit')
    fileset = InitialFileSet.new(params)
    info = Kata::create_new(fileset)
    id = info[:id]
    assert_equal 10, id.length
    kata_dir = params[:katas_root_dir] + '/' + id[0..1] + '/' + id[2..9]
    assert File.directory?(kata_dir), "File.directory?(#{kata_dir})"
    
    messages_rb = kata_dir + '/messages.rb'
    assert File.exists?(messages_rb), "File.exists?(#{messages_rb})"
    assert_equal [ ], eval(IO.read(messages_rb))
    
    manifest_rb = kata_dir + '/manifest.rb'
    assert File.exists?(manifest_rb), "File.exists?(#{manifest_rb})"
    manifest = eval(IO.read(manifest_rb))
    assert_equal 'Yahtzee', manifest[:exercise]
    assert_equal 'Yahtzee', info[:exercise]
    assert_equal 'Java JUnit', manifest[:language]
    assert_equal 'Java JUnit', info[:language]
    assert_equal 'Jon Jagger', manifest[:name]
    assert_equal 'Jon Jagger', info[:name]
    assert_equal info[:id], manifest[:id]
    assert info.has_key?(:created), "info.has_key?(:created)"
    assert manifest.has_key?(:created), "manifest.has_key?(:created)"
    assert_equal info[:created], manifest[:created]
    
    sandbox = kata_dir + '/sandbox'
    assert File.directory?(sandbox), "File.Directory?(#{sandbox})"
    hidden_file = sandbox + '/junit-4.7.jar'    
    assert File.exists?(hidden_file), "File.exists?(#{hidden_file})"

    assert !info.has_key?(:visible_files), "!info.has_key?(:visible_files)"
    assert !info.has_key?(:unit_test_framework), "!info.has_key?(:unit_test_framework)"
    assert !info.has_key?(:tab_size), "!info.has_key?(:tab_size)"
  end
  
end
