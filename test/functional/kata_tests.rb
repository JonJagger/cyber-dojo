require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

# > ruby test/functional/kata_tests.rb

class KataTests < ActionController::TestCase

  Root_test_folder = RAILS_ROOT + '/test/test_katas'

  def root_test_folder_reset
    system("rm -rf #{Root_test_folder}")
    Dir.mkdir Root_test_folder
  end

  def make_params
    { :kata_name => 'Jon Jagger', 
      :kata_root => Root_test_folder,
      :filesets_root => RAILS_ROOT +  '/filesets',
      'exercise' => 'Unsplice',
      'language' => 'C++',
      :browser => 'None (test)'
    }
  end
  
  def test_that_root_katas_folder_initially_does_not_contain_index_file
    root_test_folder_reset
    assert !File.exists?(Root_test_folder + '/index.rb');
  end
  
  def test_that_creating_and_configuring_a_new_kata_creates_index_file_in_root_katas_folder
    root_test_folder_reset
    params = make_params
    assert Kata::create(params)
    Kata::configure(params)    
    index_filename = Root_test_folder + '/index.rb'
    assert File.exists?(index_filename);
    index = eval IO.read(index_filename)
    assert_equal 1, index.length
    assert_equal params[:kata_name], index.last[:name]
  end
  
  def test_that_creating_a_second_kata_appends_an_entry_to_the_index_file_in_root_katas_folder
    root_test_folder_reset
    params = make_params
    Kata::create(params)
    Kata::configure(params)    
    params[:kata_name] += '2'
    Kata::create(params)
    Kata::configure(params)    
    index_filename = Root_test_folder + '/index.rb'
    assert File.exists?(index_filename);
    index = eval IO.read(index_filename)
    assert_equal 2, index.length
    assert_equal params[:kata_name], index.last[:name]
  end
  
  def test_that_creating_a_new_kata_succeeds_and_creates_root_folder
    root_test_folder_reset
    params = make_params
    assert Kata::create(params)
    kata = Kata.new(params)
    assert File.exists?(kata.folder), 'inner/outer folder created'
  end
  
  def test_that_trying_to_create_an_existing_kata_fails
    root_test_folder_reset
    params = make_params
    assert Kata::create(params)
    assert !Kata::create(params)    
  end
  
  def test_that_configuring_a_new_kata_creates_a_sandbox_folder_containing_hidden_files
    root_test_folder_reset
    params = make_params
    params['language'] = 'Java'
    assert Kata::create(params)
    Kata::configure(params)    
    kata = Kata.new(params)
    sandbox = kata.folder + '/sandbox'
    assert File.exists?(sandbox), 'inner/outer/sandbox folder created'
    assert File.exists?(sandbox + '/junit-4.7.jar')
  end
  
  def test_that_configuring_a_new_kata_creates_two_core_files
    root_test_folder_reset
    params = make_params
    assert Kata::create(params)
    Kata::configure(params)
    kata = Kata.new(params)
    assert File.exists?(kata.messages_filename), 'messages.rb created'
    assert File.exists?(kata.manifest_filename), 'manifest.rb created'
  end

  def test_that_you_can_create_an_avatar_in_a_kata
    root_test_folder_reset
    params = make_params
    assert Kata::create(params)
    Kata::configure(params)    
    kata = Kata.new(params)
    
    avatar_name = Avatar::names.shuffle[0]
    avatar = Avatar.new(kata, avatar_name)
  end
  
  def test_avatar_names
    root_test_folder_reset
    params = make_params
    assert Kata::create(params)
    Kata::configure(params)    
    kata = Kata.new(params)
    Avatar.new(kata, 'lion')
    Avatar.new(kata, 'hippo')
    assert_equal ['hippo', 'lion'], kata.avatar_names.sort
  end
  
  def test_all_increments
    root_test_folder_reset
    params = make_params
    assert Kata::create(params)
    Kata::configure(params)    
    kata = Kata.new(params)
    Avatar.new(kata, 'lion')
    Avatar.new(kata, 'hippo')
    expected = { "hippo" => [ ], "lion" => [ ] }
    assert_equal expected, kata.all_increments
  end
  
end
