require File.dirname(__FILE__) + '/../test_helper'

class DojoTests < ActionController::TestCase
  
  def setup
    @dir = '/blah'
    @dojo = Dojo.new(@dir)
  end
  
  test "dir is as set in ctor" do
    assert_equal @dir, @dojo.dir
  end

  test "[id] gives you kata which knows its dir" do
    assert_equal @dir+'/katas/12/34567890', @dojo['1234567890'].dir
  end

  test "language gives you language which knows its name" do
    assert_equal 'xxx', @dojo.language('xxx').name
  end
  
  test "exercise gives you exercise which knows its name" do
    assert_equal 'yyy', @dojo.exercise('yyy').name
  end
  
end
