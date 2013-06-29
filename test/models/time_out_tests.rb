require File.dirname(__FILE__) + '/../test_helper'

class TimeOutTests < ActionController::TestCase

  def teardown
    Thread.current[:file] = nil
    system("rm -rf #{root_dir}/katas/*")
    system("rm -rf #{root_dir}/zips/*")    
  end

  test "that code with infinite loop times out to amber and doesnt leak processes" do
    kata = make_kata('Ruby-installed-and-working', exercise='Dummy')
    avatar_name = Avatar::names.shuffle[0]
    avatar = Avatar.create(kata, avatar_name)
    visible_files = avatar.visible_files
    filename = 'untitled.rb'    
    code = visible_files[filename]
    visible_files[filename] = code.sub('42', 'while true;end')
    
    ps_count_before = ps_count
    print 't'
    STDOUT.flush
    output = run_tests(avatar, visible_files, timeout = 5)

    assert_match(/Terminated by the cyber-dojo server after \d+ seconds?/, output)
    assert_equal :amber, avatar.traffic_lights.last[:colour]
    
    ps_count_after = ps_count    
    # This next text sometimes fails and I haven't yet determined why...
    assert_equal ps_count_before, ps_count_after, 'proper cleanup of shell processes'    
  end
  
  def ps_count
    `ps aux | grep -E "(cyber-dojo)"`.lines.count
  end
  
end
