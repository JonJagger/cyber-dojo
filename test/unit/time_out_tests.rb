require File.dirname(__FILE__) + '/../test_helper'

class TimeOutTests < ActionController::TestCase

  test "that_code_with_infinite_loop_times_out_to_amber_and_doesnt_leak_processes" do
    kata = make_kata('Ruby-installed-and-working', 'Dummy')
    filename = 'untitled.rb'
    avatar_name = Avatar::names.shuffle[0]
    avatar = Avatar.new(kata, avatar_name)
    visible_files = avatar.visible_files
    code = visible_files[filename]
    visible_files[filename] = code.sub('42', 'while true;end')
    
    ps_count_before = ps_count
    print 't'
    STDOUT.flush
    output = run_tests(avatar, visible_files, timeout = 5)
    assert_equal :amber, avatar.increments.last[:colour]
    ps_count_after = ps_count
    
    # This next text sometimes fails and I haven't yet determined why...
    assert_equal ps_count_before, ps_count_after, 'proper cleanup of shell processes'
    
    assert_match(/Terminated by the cyber-dojo server after \d+ seconds?/, output)
  end
  
  def ps_count
    `ps aux | grep -E "(cyber-dojo)"`.lines.count
  end
  
end
