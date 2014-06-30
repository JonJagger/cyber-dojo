#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'
require 'GitDiff'

class GitDiffMostChangedTests < CyberDojoTestBase

  include GitDiff

  test "when current_filename has diffs it is always the chosen id even if another file has more changed lines" do
    current_filename = 'def'
    diffs = [ ]
    diffs << {
      :deleted_line_count => 22,
      :added_line_count => 32,
      :id => 'jj23',
      :filename => 'abc',
    }
    diffs << {
      :deleted_line_count => 3,
      :added_line_count => 1,
      :id => 'jj24',
      :filename => current_filename,
    }
    id = most_changed_lines_file_id(diffs, current_filename)
    assert_equal 'jj24', id
  end

  #------------------------------------------------------------------

  test "when current_filename has no diffs it is chosen only if no other file has any diffs either" do
    current_filename = 'def'
    diffs = [ ]
    diffs << {
      :deleted_line_count => 0,
      :added_line_count => 0,
      :id => 'jj23',
      :filename => 'abc',
    }
    diffs << {
      :deleted_line_count => 0,
      :added_line_count => 0,
      :id => 'jj24',
      :filename => current_filename,
    }
    id = most_changed_lines_file_id(diffs, current_filename)
    assert_equal 'jj24', id
  end

  #------------------------------------------------------------------

  test "when current_filename has no diffs it is still chosen if only other file with diffs is output" do
    current_filename = 'def'
    diffs = [ ]
    diffs << {
      :deleted_line_count => 2,
      :added_line_count => 4,
      :id => 'jj23',
      :filename => 'output',
    }
    diffs << {
      :deleted_line_count => 0,
      :added_line_count => 0,
      :id => 'jj24',
      :filename => current_filename
    }
    id = most_changed_lines_file_id(diffs, current_filename)
    assert_equal 'jj24', id
  end

  #------------------------------------------------------------------

  test "when current_filename has no diffs and another non-output file has diffs the current_filename is not chosen" do
    current_filename = 'def'
    diffs = [ ]
    diffs << {
      :deleted_line_count => 2,
      :added_line_count => 4,
      :id => 'jj23',
      :filename => 'not-output',
    }
    diffs << {
      :deleted_line_count => 0,
      :added_line_count => 0,
      :id => 'jj24',
      :filename => current_filename,
    }
    id = most_changed_lines_file_id(diffs, current_filename)
    assert_equal 'jj23', id
  end

  #------------------------------------------------------------------

  test "when current_filename is not present and a non-output file has diffs then the one with the most diffs is chosen" do
    diffs = [ ]
    diffs << {
      :deleted_line_count => 22,
      :added_line_count => 44,
      :id => 'jj22',
      :filename => 'output',
    }
    diffs << {
      :deleted_line_count => 2,
      :added_line_count => 4,
      :id => 'jj23',
      :filename => 'not-output',
    }
    diffs << {
      :deleted_line_count => 0,
      :added_line_count => 0,
      :id => 'jj24',
      :filename => 'also-not-output',
    }
    diffs << {
      :deleted_line_count => 3,
      :added_line_count => 4,
      :id => 'jj25',
      :filename => 'again-not-output',
    }
    current_filename = 'not-present'
    id = most_changed_lines_file_id(diffs, current_filename)
    assert_equal 'jj25', id
  end

  #------------------------------------------------------------------

  test "when current_filename is not present and no non-output file has diffs then largest non-output non-instructions file is chosen" do
    diffs = [ ]
    diffs << {
      :deleted_line_count => 23,
      :added_line_count => 23,
      :id => 'jj22',
      :filename => 'output',
      :content => '13453453534535345345'
    }
    diffs << {
      :deleted_line_count => 0,
      :added_line_count => 0,
      :id => 'jj23',
      :filename => 'not-output',
      :content => '1'
    }
    diffs << {
      :deleted_line_count => 0,
      :added_line_count => 0,
      :id => 'jj24',
      :filename => 'also-not-output',
      :content => '1234'
    }
    current_filename = nil
    id = most_changed_lines_file_id(diffs, current_filename)
    assert_equal 'jj24', id
  end

end
