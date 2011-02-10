require 'test_helper'

class KataControllerTest < ActionController::TestCase

  def test_creating_a_new_dojo_builds_git_like_folder_structure
    params = {}
    params[:root_folder] = 'test_dojos'
    #params[:name] = 
    #
    #if !File.directory? name
    #  Dir.mkdir name
    #end
    
  end
  
  
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
