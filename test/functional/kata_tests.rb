require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

# > ruby test/functional/kata_tests.rb

class KataTests < ActionController::TestCase

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
      'name' => 'Valentine'
    }
  end

  def make_kata(language = 'Ruby')
    params = make_params(language)
    fileset = InitialFileSet.new(params)
    info = Kata::create_new(fileset)
    params[:id] = info[:id]
    Kata.new(params)    
  end
    
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  def test_that_root_katas_dir_initially_does_not_contain_index_file
    root_test_dir_reset
    assert !File.exists?(ROOT_TEST_DIR + '/index.rb');
  end
  
  def Xtest_that_creating_and_configuring_a_new_kata_creates_index_file_in_root_katas_dir
    root_test_dir_reset
    make_kata
    index_filename = Root_test_dir + '/index.rb'
    assert File.exists?(index_filename);
    index = eval IO.read(index_filename)
    assert_equal 1, index.length
    assert_equal params[:kata_name], index.last[:name]
  end
  
  def Xtest_that_creating_a_second_kata_appends_an_entry_to_the_index_file_in_root_katas_dir
    root_test_dir_reset
    kata = make_kata    
    #params = make_params
    #Kata::create(params)
    #Kata::configure(params)    
    #params[:kata_name] += '2'
    #Kata::create(params)
    #Kata::configure(params)    
    #index_filename = Root_test_folder + '/index.rb'
    #assert File.exists?(index_filename);
    #index = eval IO.read(index_filename)
    #assert_equal 2, index.length
    #assert_equal params[:kata_name], index.last[:name]
  end
  
  def test_that_creating_a_new_kata_succeeds_and_creates_root_dir
    root_test_dir_reset
    kata = make_kata
    assert File.exists?(kata.dir), 'inner/outer dir created'
  end
  
  def Xtest_that_trying_to_create_an_existing_kata_fails
    root_test_dir_reset
    params = make_params
    #assert Kata::create(params)
    #assert !Kata::create(params)    
  end
  
  def test_that_configuring_a_new_kata_creates_a_sandbox_folder_containing_hidden_files
    root_test_dir_reset
    kata = make_kata('Java JUnit')
    sandbox = kata.dir + '/sandbox'
    assert File.exists?(sandbox), 'inner/outer/sandbox folder created'
    assert File.exists?(sandbox + '/junit-4.7.jar')
  end
  
  def test_that_configuring_a_new_kata_creates_two_core_files
    root_test_dir_reset
    kata = make_kata
    assert File.exists?(kata.dir + '/messages.rb'), 'messages.rb created'
    assert File.exists?(kata.dir + '/manifest.rb'), 'manifest.rb created'
  end

  def test_that_you_can_create_an_avatar_in_a_kata
    root_test_dir_reset
    kata = make_kata    
    avatar_name = 'hippo'
    avatar = Avatar.new(kata, avatar_name)
    assert 'hippo', avatar.name
  end
  
  def test_avatar_names
    root_test_dir_reset
    kata = make_kata
    Avatar.new(kata, 'lion')
    Avatar.new(kata, 'hippo')
    assert_equal ['hippo', 'lion'], kata.avatar_names.sort
  end
  
  def test_all_increments_initially_empty
    root_test_dir_reset
    kata = make_kata
    Avatar.new(kata, 'lion')
    Avatar.new(kata, 'hippo')
    expected = { "hippo" => [ ], "lion" => [ ] }
    assert_equal expected, kata.all_increments
  end
  
end
