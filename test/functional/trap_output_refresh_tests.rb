require File.dirname(__FILE__) + '/../test_helper'

# > ruby test/functional/trap_output_refresh_tests.rb

class TrapOutputRefreshTests < ActionController::TestCase
  
  test "output is correct after refresh" do
    language = 'C assert'
    kata = make_kata(language)
    avatar = Avatar.new(kata, 'lion')
    output = run_tests(avatar, avatar.visible_files)
    # now refresh
    avatar = Avatar.new(kata, 'lion')
    assert_equal output, avatar.visible_files['output']
  end    
      
end
