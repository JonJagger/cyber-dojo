require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

# > ruby test/functional/new_kata_tests.rb

class NewKataTests < ActionController::TestCase

  include Files
  extend Files
  
  Root_test_dir = RAILS_ROOT + '/test/katas'

  def root_test_dir_reset
    system("rm -rf #{Root_test_dir}")
    Dir.mkdir Root_test_dir
  end

  def make_params
    { :kata_name => 'Jon Jagger', 
      :kata_root => Root_test_dir,
      :filesets_root => RAILS_ROOT +  '/filesets',
      'exercise' => 'Unsplice',
      'language' => 'Java',
      :browser => 'None (test)'
    }
  end
  
  def make_fileset(params)
    InitialFileSet.new(params[:filesets_root], params['language'], params['exercise'])
  end
  
  def test_create_new_using_uuid
    root_test_dir_reset
    params = make_params
    fileset = make_fileset(params)
    info = Kata::create_new(fileset, params)
    uuid = info[:uuid]
    assert_equal 10, uuid.length
    kata_dir = params[:kata_root] + '/' + uuid[0..1] + '/' + uuid[2..9]
    assert File.directory?(kata_dir), "File.directory?(#{kata_dir})"
    
    messages_rb = kata_dir + '/messages.rb'
    assert File.exists?(messages_rb), "File.exists?(#{messages_rb})"
    assert_equal [ ], eval(IO.read(messages_rb))
    
    manifest_rb = kata_dir + '/manifest.rb'
    assert File.exists?(manifest_rb), "File.exists?(#{manifest_rb})"
    manifest = eval(IO.read(manifest_rb))
    assert_equal 'Unsplice', manifest[:exercise]
    assert_equal 'Unsplice', info[:exercise]
    assert_equal 'Java', manifest[:language]
    assert_equal 'Java', info[:language]
    assert_equal 'Jon Jagger', manifest[:name]
    assert_equal 'Jon Jagger', info[:name]
    assert_equal info[:uuid], manifest[:uuid]
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
