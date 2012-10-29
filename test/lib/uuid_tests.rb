require File.dirname(__FILE__) + '/../test_helper'
require 'Uuid'

class UuidTests < ActionController::TestCase

  test "uuid is 10 chars long" do
    assert_equal 10, Uuid.gen.length
  end    
            
  test "uuid contains only 0-9 and A-E chars" do
    (1..10).each do |i|
      (0..20).each do |n|
        id = Uuid.gen
        id.chars.each do |char|
          assert "0123456789ABCDEF".include?(char),
               "\"0123456789ABCDEF\".include?(#{char})" + id
        end    
      end
    end    
  end
  
end

