require File.dirname(__FILE__) + '/../test_helper'
require 'Uuid'

class UuidTests < ActionController::TestCase

  test "uses id if supplied - useful for testing" do
    given = 'ABCDE12345'
    id = Uuid.new(given)
    assert_equal given, id.to_s
  end

  test "generates an id if one is not supplied" do
    id = Uuid.new
    assert_not_equal 'ABCDE12345', id.to_s
  end
  
  test "id is 10 chars long" do
    assert_equal 10, Uuid.new.to_s.length
  end    
            
  test "id contains only 0-9 and A-E chars" do
    (0..20).each do |n|
      id = Uuid.new.to_s
      id.chars.each do |char|
        assert "0123456789ABCDEF".include?(char),
             "\"0123456789ABCDEF\".include?(#{char})" + id
      end    
    end
  end
  
  test "id.inner is first 2 chars" do
    (0..20).each do |n|
      id = Uuid.new
      assert_equal 2, id.inner.length
      assert_equal id.to_s[0..1], id.inner
    end
  end
  
  test "id.outer is last 8 chars" do
    (0..20).each do |n|
      id = Uuid.new
      assert_equal 8, id.outer.length
      assert_equal id.to_s[2..-1], id.outer
    end
  end

  test "if id is empty string inner and outer return empty string not nil" do
    id = Uuid.new('')
    assert_equal '', id.inner
    assert_equal '', id.outer
  end
  
end

