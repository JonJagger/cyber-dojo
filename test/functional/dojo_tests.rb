require 'test_helper'

class DojoTests < ActionController::TestCase

  Root_folder = 'test_dojos'

  def root_test_folder_reset
    system("rm -rf #{Root_folder}")
    Dir.mkdir Root_folder
  end
  
  def test_creating_a_new_dojo_succeeds_and_builds_git_like_folder_structure
    root_test_folder_reset
    name = 'JonJagger'
    params = { :name => name, :root_folder => Root_folder }
    assert Dojo::create(params)
    dojo = Dojo.new(params)
    assert File.exists?(dojo.folder), 'outer folder created'
    assert File.exists?(dojo.ladder_filename), 'ladder.rb created'
    assert File.exists?(dojo.rotation_filename), 'rotation.rb created'
    assert File.exists?(dojo.manifest_filename), 'manifest.rb created'
  end

  def test_creating_existing_dojo_fails
    root_test_folder_reset
    name = 'JonJagger'
    params = { :name => name, :root_folder => Root_folder }
    assert Dojo::create(params)
    assert !Dojo::create(params)    
  end
  
  def test_creating_a_new_dojo_with_specified_duration
    root_test_folder_reset
    name = 'JonJagger'
    params = { :name => name, :root_folder => Root_folder, :minutes_duration => 65 }
    assert Dojo::create(params)
    dojo = Dojo.new(params)
    manifest = eval IO.read(dojo.manifest_filename)
    assert_equal 65, manifest[:minutes_duration]    
  end
  
  
  #-----------------------------------------------------------------------------
  #def test_parse_execution_terminated

  def test_makefile_filter_filename_not_makefile
     name     = 'not_makefile'
     content  = "    abc"
     actual   = TestRunner.makefile_filter(name, content)
     expected = "    abc"
     assert_equal expected, actual
  end

  def test_makefile_filter_filename_is_makefile
     name     = 'makefile'
     content  = "    abc"
     actual   = TestRunner.makefile_filter(name, content)
     expected = "\tabc"
     assert_equal expected, actual
  end

  def test_makefile_filter_filename_is_Makefile_with_uppercase_M
     name     = 'Makefile'
     content  = "    abc"
     actual   = TestRunner.makefile_filter(name, content)
     expected = "\tabc"
     assert_equal expected, actual
  end

end
