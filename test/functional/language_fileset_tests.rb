require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/language_fileset_tests.rb

class LanguageFileSetTests < ActionController::TestCase

  Root_test_folder = 'test_dojos'

  def root_test_folder_reset
    system("rm -rf #{Root_test_folder}")
    Dir.mkdir Root_test_folder
  end

  def make_params
    { :name => 'Jon Jagger', 
      :dojo_root => Dir.getwd + '/' + Root_test_folder,
      :filesets_root => Dir.getwd + '/../filesets'
    }
  end
  
  def test_that_initial_fileset_for_csharp_is_green
    root_test_folder_reset
    params = make_params
    assert Dojo::create(params)
    dojo = Dojo.new(params)
    avatar = Avatar.new(dojo, nil, { 'language' => 'C#' })    
    manifest = {}
    avatar.read_most_recent(manifest)
    increments = avatar.run_tests(manifest)
    assert_equal :passed, increments.last[:outcome]     
  end
    
end
