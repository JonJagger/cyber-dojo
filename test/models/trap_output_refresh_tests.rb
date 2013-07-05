require File.dirname(__FILE__) + '/../test_helper'

class TrapOutputRefreshTests < ActionController::TestCase
  
  def teardown
    Thread.current[:file] = nil
    system("rm -rf #{root_dir}/katas/*")
    system("rm -rf #{root_dir}/zips/*")    
  end
  
  test "output is correct on refresh" do
    language = 'Ruby-installed-and-working'
    kata = make_kata(language)
    avatar = Avatar.create(kata, 'lion')

    visible_files = avatar.visible_files
    output = run_tests(avatar, visible_files)
    visible_files['output'] = output
    
    traffic_light = { :colour => 'amber' }
    avatar.save_run_tests(visible_files, traffic_light)
    
    # now refresh
    avatar = Avatar.new(kata, 'lion')
    assert_equal output, avatar.visible_files['output']
  end    
      
end
