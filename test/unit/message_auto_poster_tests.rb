require File.dirname(__FILE__) + '/../test_helper'
require 'avatar'
require 'DateTimeExtensions'
require 'Messages'


class AutoPostMessageTests < ActionController::TestCase

  include Messages
  
  class MockAvatar
    def name; "frog"; end
  end
  
  def create_avatar
    avatar = MessageAutoPoster.new(MockAvatar.new())
  end
  
  def test_increment_queries
    assert Increment.new({:outcome => :passed}).passed?
    assert !Increment.new({:outcome => :failed}).passed?
  end

  def test_first_test_passing
    avatar = create_avatar
    assert !avatar.just_passed_first_test?(Increment.all([{:outcome => :failed}]))
    assert avatar.just_passed_first_test?(Increment.all([{:outcome => :failed},{:outcome=>:passed}]))
    assert !avatar.just_passed_first_test?(Increment.all([{:outcome => :passed},{:outcome=>:passed}]))
  end
  
  def test_refactoring_streak
    avatar = create_avatar
    assert !avatar.refactoring_streak?(Increment.all([]))    
    no_streak = [{:outcome => :passed}] * 4 
    assert !avatar.refactoring_streak?(Increment.all(no_streak))
    streak = [{:outcome => :passed}] * 5
    assert avatar.refactoring_streak?(Increment.all(streak))
    no_new_streak = [{:outcome => :passed}] * 6
    assert !avatar.refactoring_streak?(Increment.all(no_new_streak))
    new_streak = [{:outcome => :passed}] * 10
    assert avatar.refactoring_streak?(Increment.all(new_streak))
    
    interrupted_streak = [
      {:outcome => :passed},
      {:outcome => :passed},
      {:outcome => :failed},
      {:outcome => :passed},
      {:outcome => :passed},
      {:outcome => :passed},
      ]
      assert !avatar.refactoring_streak?(Increment.all(interrupted_streak))      
  end
  
end
