require File.dirname(__FILE__) + '/../test_helper'
require 'parse_run_tests_output_helper'

# > ruby test/functional/timeout_tests.rb

class TimeOutTests < ActionController::TestCase

  include ParseRunTestsOutputHelper

  ROOT_TEST_DIR = RAILS_ROOT + '/test/katas'

  def root_test_dir_reset
    system("rm -rf #{ROOT_TEST_DIR}")
    Dir.mkdir ROOT_TEST_DIR
  end

  def make_params(language)
    params = {
      :katas_root_dir => ROOT_TEST_DIR,
      :filesets_root_dir => RAILS_ROOT +  '/filesets',
      :browser => 'Firefox',
      'language' => language,
      'exercise' => 'Yahtzee',
      'name' => 'Jon Jagger'
    }
  end

  def ps_count
    `ps aux | grep -E "(cyberdojo|make|run\.tests)"`.lines.count
  end
  
  def test_that_code_with_infinite_loop_times_out_to_amber_and_doesnt_leak_processes
    root_test_dir_reset
    
    params = make_params('C Assert')
    fileset = InitialFileSet.new(params)
    info = Kata::create_new(fileset)
    params[:id] = info[:id]
    kata = Kata.new(params)    
    
    filename = 'untitled.c'
    avatar_name = Avatar::names.shuffle[0]
    avatar = Avatar.new(kata, avatar_name)
    visible_files = avatar.visible_files
    code = visible_files[filename]
    visible_files[filename] = code.sub('return 42;', 'for(;;);')
    
    ps_count_before = ps_count
    output = avatar.run_tests(visible_files)
    inc = parse(fileset.unit_test_framework, output)
    assert_equal inc[:outcome], :amber
    ps_count_after = ps_count
    assert_equal ps_count_before, ps_count_after, 'proper cleanup of shell processes'
    
    assert_not_nil output =~ /Terminated by the CyberDojo server after 10 seconds/
  end
  
end
