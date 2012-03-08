require File.dirname(__FILE__) + '/../test_helper'
require 'Uuid'

class UuidTests < ActionController::TestCase

  test "uuid is 10 chars long" do
    assert_equal 10, Uuid.gen.length
  end    
            
  test "uuid contains only 2-9 and A-E chars" do
    # I don't want 0 in the id as it clashes with letter O
    # I don't want 1 in the id as it clashes with letter l (ell)
    (0..20).each do |n| 
      Uuid.gen.chars.each do |char|
        assert "23456789ABCDEF".include?(char),
             "\"23456789ABCDEF\".include?(#{char})"
      end    
    end
  end
  
end

