require File.dirname(__FILE__) + '/../test_helper'

class TimeOutTests < ActionController::TestCase

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
    delta = {
      :changed => visible_files.keys,
      :unchanged => [ ],
      :deleted => [ ],
      :new => [ ]      
    }    
    output = run_test(delta, avatar, visible_files, timeout = 5)
    assert_match(/Terminated by the cyber-dojo server after \d+ seconds?/, output)
    assert_equal 'amber', avatar.traffic_lights.last['colour']
    ps_count_after = ps_count    
    # This often fails with
    # <1> expected but was
    # <2>
    assert_equal ps_count_before, ps_count_after, 'proper cleanup of shell processes'    
  end
  
  def ps_count
    `ps aux | grep -E "(cyber-dojo)"`.lines.count
  end
  
end
