require File.dirname(__FILE__) + '/../test_helper'
require 'GitDiff'

# > ruby test/functional/git_diff_most_changed_tests.rb

class GitDiffMostChangedTests < ActionController::TestCase

  include GitDiff

  
  def test_when_no_diffs_at_an_id_is_returned_if_no_output_is_present
    diffs = []
    diffs << {
      :deleted_line_count => 0,
      :id => 'jj23',          
      :name => 'abc',
      :added_line_count => 0,
      :content => '',      
    }
    diffs << {
      :deleted_line_count => 0,
      :id => 'jj24',          
      :name => 'def',
      :added_line_count => 0,
      :content => '',      
    }
    id = most_changed_lines_file_id(diffs)
    assert_equal true, id == 'jj23' or id == 'jj24'      
  end

  #------------------------------------------------------------------
  
  def test_when_no_diffs_at_all_output_id_is_returned_if_output_is_present
    diffs = []
    diffs << {
      :deleted_line_count => 0,
      :id => 'jj23',          
      :name => 'abc',
      :added_line_count => 0,
      :content => '',      
    }
    diffs << {
      :deleted_line_count => 0,
      :id => 'jj24',          
      :name => 'output',
      :added_line_count => 0,
      :content => '',      
    }
    assert_equal 'jj24', most_changed_lines_file_id(diffs)     
  end

  #------------------------------------------------------------------
  
  def test_when_some_diffs_most_changed_lines_file_id_is_returned
    diffs = []
    diffs << {
      :deleted_line_count => 1,
      :id => 'jj23',          
      :name => 'abc',
      :added_line_count => 0,
      :content => '',      
    }
    diffs << {
      :deleted_line_count => 0,
      :id => 'jj24',          
      :name => 'output',
      :added_line_count => 0,
      :content => '',      
    }
    assert_equal 'jj23', most_changed_lines_file_id(diffs)     
  end
  
end
