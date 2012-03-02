require File.dirname(__FILE__) + '/../test_helper'

# > ruby test/functional/avatar_tests.rb

class AvatarTests < ActionController::TestCase

  test "there are no increments before first test run" do
    kata = make_kata('C assert')
    avatar = Avatar.new(kata, 'wolf')    
    assert_equal [ ], avatar.increments    
  end
  
  test "increments does not contain output" do
    kata = make_kata('C assert')
    avatar = Avatar.new(kata, 'wolf')    
    run_tests(avatar, avatar.visible_files)
    increments = avatar.increments
    assert_equal 1, increments.length
    assert_equal nil, increments.last[:run_tests_output]
  end
  
end
