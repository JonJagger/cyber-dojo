require File.dirname(__FILE__) + '/../test_helper'

# > cd cyberdojo/test
# > ruby functional/dojo_tests.rb

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
      'kata' => 'Unsplice (*)',
      'language' => 'C++'    
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
    avatar = dojo.create_avatar() #filesets)
    assert avatar != nil    
    assert File.exists?(avatar.folder), 'avatar folder created'    
  end
  
  def test_that_you_cant_create_an_avatar_in_a_full_dojo
    root_test_folder_reset
    params = make_params
    assert Dojo::create(params)
    Dojo::configure(params)    
    dojo = Dojo.new(params)
    names = []
    (0...Avatar::names.length).each do |n| 
      avatar = dojo.create_avatar()
      assert avatar != nil
      names << avatar.name
    end
    assert_equal Avatar::names.sort, names.sort
    # and one more time... 
    avatar = dojo.create_avatar()
    assert avatar == nil    
  end

end
