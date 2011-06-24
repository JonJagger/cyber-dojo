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
  
  def test_that_code_with_infinite_loop_times_out
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
  end
  
  def test_that_reduced_max_run_tests_duration_stops_infinite_loop_earlier
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
    kata = avatar.kata 
    kata.manifest[:max_run_tests_duration] = 2
    started = Time.now
    increments = avatar.run_tests(manifest, kata)
    ended = Time.now
    info = avatar.name + ', ' + language
    terminated_message = "Execution terminated after 2 seconds"
    assert_equal terminated_message, manifest[:output]
    time_taken = (ended - started).to_i
    assert time_taken > 0 && time_taken < 3;
  end
  
end
