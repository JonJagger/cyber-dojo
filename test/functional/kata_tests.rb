require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

# > ruby test/functional/kata_tests.rb

class KataTests < ActionController::TestCase

  include Files
  extend Files
  
  Root_test_folder = RAILS_ROOT + '/test/test_katas'

  def root_test_folder_reset
    system("rm -rf #{Root_test_folder}")
    Dir.mkdir Root_test_folder
    #file_write(Root_test_folder + '/index.rb', [ ])
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
  
  def test_create_new_using_uuid
    root_test_folder_reset
    params = make_params
    params['language'] = 'Java'    
    fileset = InitialFileSet.new(params[:filesets_root], params['language'], params['exercise'])
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
    assert File.exists?(kata.dir), 'inner/outer dir created'
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
    sandbox = kata.dir + '/sandbox'
    assert File.exists?(sandbox), 'inner/outer/sandbox folder created'
    assert File.exists?(sandbox + '/junit-4.7.jar')
  end
  
  def test_that_configuring_a_new_kata_creates_two_core_files
    root_test_folder_reset
    params = make_params
    assert Kata::create(params)
    Kata::configure(params)
    kata = Kata.new(params)
    assert File.exists?(kata.dir + '/messages.rb'), 'messages.rb created'
    assert File.exists?(kata.dir + '/manifest.rb'), 'manifest.rb created'
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
