require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

# > ruby test/functional/dojo_tests.rb

class DojoTests < ActionController::TestCase

  Root_test_folder = RAILS_ROOT + '/test/test_dojos'

  def root_test_folder_reset
    system("rm -rf #{Root_test_folder}")
    Dir.mkdir Root_test_folder
  end

  def make_params
    { :dojo_name => 'Jon Jagger', 
      :dojo_root => Root_test_folder,
      :filesets_root => RAILS_ROOT +  '/filesets',
      'kata' => 'Unsplice',
      'language' => 'C++',
      :browser => 'None (test)'
    }
  end
  
  def test_that_root_dojos_folder_initially_does_not_contain_index_file
    root_test_folder_reset
    assert !File.exists?(Root_test_folder + '/index.rb');
  end
  
  def test_that_creating_and_configuring_a_new_dojo_creates_index_file_in_root_dojos_folder
    root_test_folder_reset
    params = make_params
    assert Dojo::create(params)
    Dojo::configure(params)    
    index_filename = Root_test_folder + '/index.rb'
    assert File.exists?(index_filename);
    index = eval IO.read(index_filename)
    assert_equal 1, index.length
    assert_equal params[:dojo_name], index.last[:name]
  end
  
  def test_that_creating_a_second_dojo_appends_an_entry_to_the_index_file_in_root_dojos_folder
    root_test_folder_reset
    params = make_params
    Dojo::create(params)
    Dojo::configure(params)    
    params[:dojo_name] += '2'
    Dojo::create(params)
    Dojo::configure(params)    
    index_filename = Root_test_folder + '/index.rb'
    assert File.exists?(index_filename);
    index = eval IO.read(index_filename)
    assert_equal 2, index.length
    assert_equal params[:dojo_name], index.last[:name]
  end
  
  def test_that_creating_a_new_dojo_succeeds_and_creates_root_folder
    root_test_folder_reset
    params = make_params
    assert Dojo::create(params)
    dojo = Dojo.new(params)
    assert File.exists?(dojo.folder), 'inner/outer folder created'
  end
  
  def test_that_trying_to_create_an_existing_dojo_fails
    root_test_folder_reset
    params = make_params
    assert Dojo::create(params)
    assert !Dojo::create(params)    
  end
  
  def test_that_configuring_a_new_dojo_creates_two_core_files
    root_test_folder_reset
    params = make_params
    assert Dojo::create(params)
    Dojo::configure(params)
    dojo = Dojo.new(params)
    assert File.exists?(dojo.messages_filename), 'messages.rb created'
    assert File.exists?(dojo.manifest_filename), 'manifest.rb created'
  end

  def test_that_you_can_create_an_avatar_in_a_dojo
    root_test_folder_reset
    params = make_params
    assert Dojo::create(params)
    Dojo::configure(params)    
    dojo = Dojo.new(params)
    
    avatar_name = Avatar::names.shuffle[0]
    avatar = Avatar.new(dojo, avatar_name)
  end
  
  def test_that_you_cant_recreate_an_avatar_folder
    root_test_folder_reset
    params = make_params
    assert Dojo::create(params)
    Dojo::configure(params)    
    dojo = Dojo.new(params)
    avatar_name = Avatar::names.shuffle[0]
    assert dojo.create_new_avatar_folder(avatar_name)
    assert !dojo.create_new_avatar_folder(avatar_name)
  end

end
