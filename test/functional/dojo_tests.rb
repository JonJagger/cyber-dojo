require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/dojo_tests.rb

class DojoTests < ActionController::TestCase

  Root_test_folder = 'test_dojos'

  def root_test_folder_reset
    system("rm -rf #{Root_test_folder}")
    Dir.mkdir Root_test_folder
  end

  def make_params
    { :dojo_name => 'Jon Jagger', 
      :dojo_root => Dir.getwd + '/' + Root_test_folder,
      :filesets_root => Dir.getwd + '/../filesets',
      'kata' => { 0 => 'Unsplice' },
      'language' => { 0 => 'C++' }    
    }
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

  def test_that_you_can_create_an_avatar_in_a_new_dojo
    root_test_folder_reset
    params = make_params
    assert Dojo::create(params)
    Dojo::configure(params)    
    dojo = Dojo.new(params)
    kata = FileSet.new(params[:filesets_root], 'kata').choices.shuffle[0]
    language = FileSet.new(params[:filesets_root], 'language').choices.shuffle[0]
    filesets = { 'kata' => kata, 'language' => language } 
    avatar = dojo.create_avatar(filesets)
    assert avatar != nil    
    assert File.exists?(avatar.folder), 'avatar folder created'    
  end
  
  def test_that_you_cant_create_an_avatar_in_a_full_dojo
    root_test_folder_reset
    params = make_params
    assert Dojo::create(params)
    Dojo::configure(params)    
    dojo = Dojo.new(params)
    filesets = { 
       'kata' => FileSet.new(params[:filesets_root], 'kata').choices.shuffle[0],
       'language' => FileSet.new(params[:filesets_root], 'language').choices.shuffle[0]
    }
    names = []
    (0...Avatar::names.length).each do |n| 
      avatar = dojo.create_avatar(filesets)
      assert avatar != nil
      names << avatar.name
    end
    assert_equal Avatar::names.sort, names.sort
    # and one more time... 
    avatar = dojo.create_avatar(filesets)
    assert avatar == nil    
  end
  
  def test_that_a_player_can_create_a_new_avatar_with_specified_kata
    root_test_folder_reset
    params = make_params
    assert Dojo::create(params)
    Dojo::configure(params)    
    dojo = Dojo.new(params)
    kata_choice = 'Unsplice (*)'
    expected_filesets = { 'kata' => kata_choice }
    avatar = dojo.create_avatar(expected_filesets)
    actual_filesets = eval IO.read(avatar.folder + '/' + 'filesets.rb')
    assert_equal kata_choice, actual_filesets['kata']
  end
  
  def test_that_a_player_can_create_a_new_avatar_with_specified_language
    root_test_folder_reset
    params = make_params
    assert Dojo::create(params)
    Dojo::configure(params)    
    dojo = Dojo.new(params)
    language_choice = 'Ruby'
    expected_filesets = { 'language' => language_choice }
    avatar = dojo.create_avatar(expected_filesets)
    actual_filesets = eval IO.read(avatar.folder + '/' + 'filesets.rb')
    assert_equal language_choice, actual_filesets['language']
  end
  
  def test_that_a_player_can_create_a_new_avatar_with_specified_kata_and_language
    root_test_folder_reset
    params = make_params
    assert Dojo::create(params)
    Dojo::configure(params)    
    dojo = Dojo.new(params)
    kata_choice = 'Unsplice (*)'
    language_choice = 'Ruby'
    filesets = { 'kata' => kata_choice, 'language' => language_choice }
    avatar = dojo.create_avatar(filesets)
    actual_filesets = eval IO.read(avatar.folder + '/' + 'filesets.rb')
    assert_equal kata_choice, actual_filesets['kata']
    assert_equal language_choice, actual_filesets['language']
  end

end
