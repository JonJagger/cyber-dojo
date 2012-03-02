require File.dirname(__FILE__) + '/../test_helper'

# > ruby test/functional/timeout_tests.rb

class TimeOutTests < ActionController::TestCase

  test "that_code_with_infinite_loop_times_out_to_amber_and_doesnt_leak_processes" do
    params = make_params('C assert')
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
    print 't'
    STDOUT.flush
    output = run_tests(avatar, visible_files)
    assert_equal :amber, avatar.increments.last[:outcome]
    ps_count_after = ps_count
    assert_equal ps_count_before, ps_count_after, 'proper cleanup of shell processes'
    assert_match(/Terminated by the CyberDojo server after 10 seconds/, output)
  end
  
  def ps_count
    `ps aux | grep -E "(cyberdojo|make|run\.tests)"`.lines.count
  end
  
end
