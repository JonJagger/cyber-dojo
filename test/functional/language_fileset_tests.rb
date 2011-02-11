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
  
  def test_that_initial_fileset_for_all_languages_is_green
    root_test_folder_reset
    params = make_params
    assert Dojo::create(params)
    dojo = Dojo.new(params)
    FileSet.new(dojo.filesets_root, 'language').choices.each do |language|    
      avatar = Avatar.new(dojo, nil, { 'language' => language })    
      manifest = {}
      avatar.read_most_recent(manifest)
      increments = avatar.run_tests(manifest)
      info = language + ', ' + avatar.name
      assert_equal :passed, increments.last[:outcome], info
      p info      
    end

  end
    
end
