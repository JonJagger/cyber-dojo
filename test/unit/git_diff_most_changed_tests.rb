require File.dirname(__FILE__) + '/../test_helper'
require 'GitDiff'

# > ruby test/unit/git_diff_most_changed_tests.rb

class GitDiffMostChangedTests < ActionController::TestCase

  include GitDiff

  test "when no diffs an id is returned if no output is present" do
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
    
  test "when some diffs most changed lines file id is returned" do
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
  
  #------------------------------------------------------------------
  
  test "when non output file has diffs it is preferred to output" do
    diffs = []
    diffs << {
      :deleted_line_count => 1,
      :id => 'jj23',          
      :name => 'abc',
      :added_line_count => 0,
      :content => '',      
    }
    diffs << {
      :deleted_line_count => 4,
      :id => 'jj24',          
      :name => 'def',
      :added_line_count => 1,
      :content => '',      
    }    
    diffs << {
      :deleted_line_count => 5,
      :id => 'jj25',          
      :name => 'output',
      :added_line_count => 2,
      :content => '',      
    }
    assert_equal 'jj24', most_changed_lines_file_id(diffs)     
  end

end
