require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/run_tests_tests.rb

class LanguageFileSetTests < ActionController::TestCase

  Root_test_folder = 'test_dojos'

  def root_test_folder_reset
    system("rm -rf #{Root_test_folder}")
    Dir.mkdir Root_test_folder
  end

  def make_params
    { :dojo_name => 'Jon Jagger', 
      :dojo_root => Dir.getwd + '/' + Root_test_folder,
      :filesets_root => Dir.getwd + '/../filesets'
    }
  end
  
  def test_that_code_with_infinite_loop_times_out_after_10_seconds
    root_test_folder_reset
    params = make_params
    assert Dojo::create(params)
    dojo = Dojo.new(params)
    language = 'C'
    filename = 'untitled.c'
    avatar = dojo.create_avatar({ 'language' => language })    
    manifest = {}
    avatar.read_manifest(manifest)
    code = manifest[:visible_files][filename][:content]
    manifest[:visible_files][filename][:content] = code.sub('return 42;', 'for(;;);')
    increments = avatar.run_tests(manifest)
    info = avatar.name + ', ' + language
    terminated_message = "Execution terminated after 10 seconds"
    assert_equal terminated_message, manifest[:output]
    print '.'      
  end
  
end
