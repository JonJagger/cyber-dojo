require File.dirname(__FILE__) + '/../test_helper'

class Cyber_DojoTests < ActionController::TestCase
  
  def setup
    @dir = '/blah'
    @cd = Cyber_Dojo.new(@dir)
  end
  
  test "dir is as set in ctor" do
    assert_equal @dir, @cd.dir
  end

  test "cd[id] gives you kata which knows its dir" do
    assert_equal @dir+'/katas/12/34567890', @cd['1234567890'].dir
  end

  test "cd.language gives you language which knows its name" do
    assert_equal 'xxx', @cd.language('xxx').name
  end
  
  test "cd.exercise gives you exercise which knows its name" do
    assert_equal 'yyy', @cd.exercise('yyy').name
  end
  
end
