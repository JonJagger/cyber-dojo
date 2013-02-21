require File.dirname(__FILE__) + '/../test_helper'

class AvatarTests < ActionController::TestCase

  def language
    'Ruby-installed-and-working'
  end
  
  test "there are no increment-traffic-lights before first test-run" do
    kata = make_kata(language)
    avatar = Avatar.new(kata, 'wolf')    
    assert_equal [ ], avatar.increments    
  end
  
  test "after first test-run increments contains one traffic-light which does not contain output" do
    kata = make_kata(language)
    avatar = Avatar.new(kata, 'wolf')    
    run_tests(avatar, avatar.visible_files)
    increments = avatar.increments
    assert_equal 1, increments.length
    assert_equal nil, increments.last[:run_tests_output]
  end
  
  test "avatar returns kata it was created with" do
    kata = make_kata(language)
    avatar = Avatar.new(kata, 'wolf')    
    assert_equal kata, avatar.kata    
  end
  
  test "diff_lines is not empty when change in files" do
    kata = make_kata(language)
    avatar = Avatar.new(kata, 'wolf')
    visible_files = avatar.visible_files
    run_tests(avatar, visible_files)
    visible_files['cyber-dojo.sh'] += 'xxxx'
    run_tests(avatar, visible_files)
    increments = avatar.increments
    assert_equal 2, increments.length
    was_tag = nil
    now_tag = nil
    actual = avatar.diff_lines(was_tag = 1, now_tag = 2)    
    assert actual.match(/^diff --git/)
  end
  
end
