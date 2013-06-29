require File.dirname(__FILE__) + '/../test_helper'

class TrapOutputRefreshTests < ActionController::TestCase
  
  def teardown
    Thread.current[:file] = nil
    system("rm -rf #{root_dir}/katas/*")
    system("rm -rf #{root_dir}/zips/*")    
  end
  
  test "output is correct after refresh" do
    language = 'Ruby-installed-and-working'
    kata = make_kata(language)
    avatar = Avatar.create(kata, 'lion')
    output = run_tests(avatar, avatar.visible_files)
    # now refresh
    avatar = Avatar.new(kata, 'lion')
    assert_equal output, avatar.visible_files['output']
  end    
      
end
