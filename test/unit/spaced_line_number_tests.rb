require File.dirname(__FILE__) + '/../test_helper'
require 'GitDiff'

# > ruby test/functional/spaced_line_number_tests.rb

class SpacedLineNumberTests < ActionController::TestCase

  include GitDiff
  
  def test_max_digits_1_2_3_4
    max_digits = 1
    (0..9).each {|n| assert_equal ' '+ n.to_s, spaced_line_number(n, max_digits), 0 }
    
    max_digits = 2
    (0..9).each   {|n| assert_equal ' ' + n.to_s, spaced_line_number(n, max_digits), 1 }
    (10..99).each {|n| assert_equal '' +  n.to_s, spaced_line_number(n, max_digits), 2 }
    
    max_digits = 3
    (0..9).each     {|n| assert_equal '  ' + n.to_s, spaced_line_number(n, max_digits), 3 }
    (10..99).each   {|n| assert_equal ' ' +  n.to_s, spaced_line_number(n, max_digits), 4 }
    (100..243).each {|n| assert_equal '' +   n.to_s, spaced_line_number(n, max_digits), 5 }
    
    max_digits = 4
    (0..9).each       {|n| assert_equal '   ' + n.to_s, spaced_line_number(n, max_digits), 6 }
    (10..99).each     {|n| assert_equal '  ' +  n.to_s, spaced_line_number(n, max_digits), 7 }
    (100..999).each   {|n| assert_equal ' ' +   n.to_s, spaced_line_number(n, max_digits), 8 }
    (1000..1234).each {|n| assert_equal '' +    n.to_s, spaced_line_number(n, max_digits), 9}    
  end

  def test_max_digits_nils_for_deleted_lines
    assert_equal ' -', spaced_line_number(nil, 1), '1'
    assert_equal ' -', spaced_line_number(nil, 2), '2'
    assert_equal '  -', spaced_line_number(nil, 3), '3'
  end
  
end


