#!/bin/bash ../test_wrapper.sh

require_relative './AppLibTestBase'

class GitDiffTests < AppLibTestBase

  include GitDiff

  test '74CA5C',
  'empty file is deleted' do

    diff_lines =
    [
      'diff --git a/sandbox/xx.rb b/sandbox/xx.rb',
      'deleted file mode 100644',
      'index e69de29..0000000'
    ].join("\n")

    actual_diffs = GitDiff::GitDiffParser.new(diff_lines).parse_all
    expected_diffs =
    {
      'a/sandbox/xx.rb' =>
      {
        :prefix_lines =>
        [
          'diff --git a/sandbox/xx.rb b/sandbox/xx.rb',
          'deleted file mode 100644',
          'index e69de29..0000000'
        ],
        :was_filename => 'a/sandbox/xx.rb',
        :now_filename => '/dev/null',
        :chunks => [ ]
      }
    }
    assert_equal expected_diffs, actual_diffs

    visible_files = { }
    expected_view = { 'xx.rb' => [ ] }

    actual_view = git_diff(diff_lines, visible_files)
    assert_equal expected_view, actual_view
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '2DE0C6',
  'non-empty file is deleted' do
    diff_lines =
    [
      'diff --git a/sandbox/non-empty.h b/sandbox/non-empty.h',
      'deleted file mode 100644',
      'index a459bc2..0000000',
      '--- a/sandbox/non-empty.h',
      '+++ /dev/null',
      '@@ -1 +0,0 @@',
      '-something',
      '\\ No newline at end of file'
    ].join("\n")

    actual_diffs = GitDiff::GitDiffParser.new(diff_lines).parse_all
    expected_diffs =
    {
      "a/sandbox/non-empty.h"=>
      {
        :prefix_lines=>
        [
          "diff --git a/sandbox/non-empty.h b/sandbox/non-empty.h",
          "deleted file mode 100644",
          "index a459bc2..0000000"
        ],
        :was_filename => "a/sandbox/non-empty.h",
        :now_filename => "/dev/null",
        :chunks =>
        [
          {
            :range =>
            {
              :was => { :start_line => 1, :size => 1 },
              :now => { :start_line => 0, :size => 0 }
            },
            :before_lines => [],
            :sections =>
            [
              {
                :deleted_lines => [ "something" ],
                :added_lines => [],
                :after_lines =>[]
              }
            ]
          }
        ]
      }
    }
    assert_equal expected_diffs, actual_diffs

    visible_files = { }
    expected_view = {
      'non-empty.h' =>
      [
        {
          :line => 'something',
          :type => :deleted,
          :number => 1
        }
      ]
    }

    actual_view = git_diff(diff_lines, visible_files)
    assert_equal expected_view, actual_view
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '70DA2C',
  "empty file is created" do
    diff_lines =
    [
      'diff --git a/sandbox/empty.h b/sandbox/empty.h',
      'new file mode 100644',
      'index 0000000..e69de29'
    ].join("\n")

    actual_diffs = GitDiff::GitDiffParser.new(diff_lines).parse_all
    expected_diffs =
    {
      nil =>  ####??????
      {
        :prefix_lines =>
        [
          'diff --git a/sandbox/empty.h b/sandbox/empty.h',
          'new file mode 100644',
          'index 0000000..e69de29'
        ],
        :was_filename => nil,
        :now_filename => nil,
        :chunks => [ ]
      }
    }
    assert_equal expected_diffs, actual_diffs

    visible_files = { }
    expected_view = { }

    actual_view = git_diff(diff_lines, visible_files)
    assert_equal expected_view, actual_view
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '76CD09',
  "non-empty file is created" do
    diff_lines =
    [
      "diff --git a/sandbox/non-empty.c b/sandbox/non-empty.c",
      "new file mode 100644",
      "index 0000000..a459bc2",
      "--- /dev/null",
      "+++ b/sandbox/non-empty.c",
      "@@ -0,0 +1 @@",
      "+something",
      "\\ No newline at end of file"
    ].join("\n")

    actual_diffs = GitDiff::GitDiffParser.new(diff_lines).parse_all
    expected_diffs =
    {
      "b/sandbox/non-empty.c" =>
      {
        :prefix_lines =>
        [
          "diff --git a/sandbox/non-empty.c b/sandbox/non-empty.c",
          "new file mode 100644",
          "index 0000000..a459bc2"
        ],
        :was_filename => "/dev/null",
        :now_filename => "b/sandbox/non-empty.c",
        :chunks =>
        [
          {
            :range =>
            {
              :was => { :start_line => 0, :size => 0 },
              :now => { :start_line => 1, :size => 1}
            },
            :before_lines => [],
            :sections =>
            [
              {
                :deleted_lines => [],
                :added_lines => [ "something" ],
                :after_lines => [ ]
              }
            ]
          }
        ]
      }
    }

    assert_equal expected_diffs, actual_diffs

    visible_files = { }
    expected_view = {
      'non-empty.c' =>
      [
        { :type => :section, :index => 0 },
        { :type => :added, :line => "something", :number => 1 }
      ]
    }

    actual_view = git_diff(diff_lines, visible_files)
    assert_equal expected_view, actual_view
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '3D94D0',
  "existing file is changed" do
    diff_lines =
    [
      "diff --git a/sandbox/non-empty.c b/sandbox/non-empty.c",
      "index a459bc2..605f7ff 100644",
      "--- a/sandbox/non-empty.c",
      "+++ b/sandbox/non-empty.c",
      "@@ -1 +1 @@",
      "-something",
      "\\ No newline at end of file",
      "+something changed",
      "\\ No newline at end of file",
    ].join("\n")

    actual_diffs = GitDiff::GitDiffParser.new(diff_lines).parse_all
    expected_diffs =
    {
      "b/sandbox/non-empty.c" =>
      {
        :prefix_lines =>
        [
          "diff --git a/sandbox/non-empty.c b/sandbox/non-empty.c",
          "index a459bc2..605f7ff 100644"
        ],
        :was_filename => "a/sandbox/non-empty.c",
        :now_filename => "b/sandbox/non-empty.c",
        :chunks =>
        [
          {
            :range =>
            {
              :was => { :start_line => 1, :size => 1 },
              :now => { :start_line => 1, :size => 1 }
            },
            :before_lines => [],
            :sections =>
            [
              {
                :deleted_lines => [ "something" ],
                :added_lines => [ "something changed"],
                :after_lines => []
              }
            ]
          }
        ]
      }
    }
    assert_equal expected_diffs, actual_diffs

    visible_files = { }
    expected_view = {
      'non-empty.c' =>
      [
        { :type => :section, :index => 0 },
        { :type => :deleted, :line => "something", :number => 1 },
        { :type => :added, :line => "something changed", :number => 1 }
      ]
    }

    actual_view = git_diff(diff_lines, visible_files)
    assert_equal expected_view, actual_view
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'AF735C',
  "unchanged file" do
    diff_lines = [].join("\n")
    actual_diffs = GitDiff::GitDiffParser.new(diff_lines).parse_all
    expected_diffs =
    {
    }
    assert_equal expected_diffs, actual_diffs
    visible_files = { 'wibble.txt' => 'content' }
    expected_view = {
      'wibble.txt' =>
      [
        { :type => :same, :line => 'content', :number => 1}
      ]
    }
    actual_view = git_diff(diff_lines, visible_files)
    assert_equal expected_view, actual_view
  end

end
