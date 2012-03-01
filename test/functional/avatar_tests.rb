require File.dirname(__FILE__) + '/../test_helper'

# > ruby test/functional/avatar_tests.rb

class AvatarTests < ActionController::TestCase

  def test_no_increments_before_first_test_run
    kata = make_kata('C assert')
    avatar = Avatar.new(kata, 'wolf')    
    assert_equal [ ], avatar.increments    
  end
  
  def test_increments_does_not_contain_output
    kata = make_kata('C assert')
    avatar = Avatar.new(kata, 'wolf')    
    run_tests(avatar, avatar.visible_files)
    increments = avatar.increments
    assert_equal 1, increments.length
    assert_equal nil, increments.last[:run_tests_output]
  end
  
end
