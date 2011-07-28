require File.dirname(__FILE__) + '/../test_helper'

# > cd cyberdojo/test
# > ruby functional/run_tests_timeout_tests.rb

class RunTestsTimeOutTests < ActionController::TestCase

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
  
  def ps_count
    `ps aux | grep -E "(cyberdojo|make|run\.tests)"`.lines.count
  end
  
  def test_that_code_with_infinite_loop_times_out_and_doesnt_leak_processes
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
    
    ps_count_before = ps_count
    increments = avatar.run_tests(manifest)
    ps_count_after = ps_count

    assert manifest[:output] =~ /\(by the CyberDojo server after 10 seconds\)$/
    assert_equal ps_count_before, ps_count_after, 'proper cleanup of shell processes'
  end
  
  def test_that_reduced_max_run_tests_duration_stops_infinite_loop_earlier_and_doesnt_leak_processes
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
    
    ps_count_before = ps_count    
    started = Time.now
    increments = avatar.run_tests(manifest, kata)
    ended = Time.now
    ps_count_after = ps_count
    
    assert manifest[:output] =~ /\(by the CyberDojo server after 2 seconds\)$/ 
    assert_equal ps_count_before, ps_count_after, 'proper cleanup of shell processes'
    
    time_taken = ended - started
    assert time_taken > 0 && time_taken < 3;
  end
  
end
