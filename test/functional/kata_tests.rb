require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

# > ruby test/functional/new_kata_tests.rb

class NewKataTests < ActionController::TestCase

  include Files
  extend Files
  
  def test_create_new_using_uuid
    root_test_dir_reset
    params = make_params('Java JUnit')
    fileset = InitialFileSet.new(params)
    info = Kata::create_new(fileset)
    id = info[:id]
    assert_equal 10, id.length
    kata_dir = params[:katas_root_dir] + '/' + id[0..1] + '/' + id[2..9]
    assert File.directory?(kata_dir), "File.directory?(#{kata_dir})"
        
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
  
  def test_that_root_katas_dir_initially_does_not_contain_index_file
    root_test_dir_reset
    assert !File.exists?(ROOT_TEST_DIR + '/index.rb');
  end
    
  def test_that_creating_a_new_kata_succeeds_and_creates_root_dir
    root_test_dir_reset
    kata = make_kata
    assert File.exists?(kata.dir), 'inner/outer dir created'
  end
    
  def test_that_you_can_create_an_avatar_in_a_kata
    root_test_dir_reset
    kata = make_kata    
    avatar_name = 'hippo'
    avatar = Avatar.new(kata, avatar_name)
    assert 'hippo', avatar.name
  end
  
  def test_multiple_avatar_names_in_a_kata
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
  
  def make_kata(language = 'Ruby')
    params = make_params(language)
    fileset = InitialFileSet.new(params)
    info = Kata::create_new(fileset)
    params[:id] = info[:id]
    Kata.new(params)    
  end
    
end
