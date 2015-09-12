#!/bin/bash ../test_wrapper.sh

require_relative './app_lib_test_base'

class DiffBugTests < AppLibTestBase

  include GitDiff

  test 'another specific real dojo that once failed a diff' do
    bad_diff_lines =
    [
      'diff --git a/sandbox/recently_used_list.cpp b/sandbox/was_recently_used_list.test.cpp',
      'similarity index 100%',
      'copy from sandbox/recently_used_list.cpp',
      'copy to sandbox/was_recently_used_list.test.cpp',
    ].join("\n")

    diff = GitDiff::GitDiffParser.new(bad_diff_lines).parse_all

    expected_diff =
    {
        :prefix_lines =>
          [
            'diff --git a/sandbox/recently_used_list.cpp b/sandbox/was_recently_used_list.test.cpp',
            'similarity index 100%',
            'copy from sandbox/recently_used_list.cpp',
            'copy to sandbox/was_recently_used_list.test.cpp',
          ],
        :was_filename => 'a/sandbox/recently_used_list.cpp',
        :now_filename => 'b/sandbox/was_recently_used_list.test.cpp',
        :chunks =>
          [
          ] # chunks
    }
    expected = {
      'b/sandbox/was_recently_used_list.test.cpp' => expected_diff
    }
    assert_equal expected, diff

  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'specific real dojo that fails diff show narrowing' do
    visible_files = { }
    visible_files['gapper.rb'] =
          [
            '',
            'def as_time(t)',
            '  [t.year, t.month, t.day, t.hour, t.min, t.sec]',
            'end',
            '',
            'def gapper(lights, from, to, secs_per_gap)',
            '  gaps = [as_time(from)]  ',
            '  while (from + secs_per_gap < to)',
            '    from += secs_per_gap;',
            '    gaps << as_time(from)',
            '  end',
            '  gaps',
            'end',
            '',
            ''
          ].join("\n")

    diff_lines =
    [
      "diff --git a/sandbox/cyberdojo.sh b/sandbox/cyberdojo.sh",
      "index ed6ef37..0f7a44b 100755",
      "--- a/sandbox/cyberdojo.sh",
      "+++ b/sandbox/cyberdojo.sh",
      "@@ -1 +1,2 @@",
      "+ruby test_each_pair.rb",
      " ruby test_gapper.rb",
      "diff --git a/sandbox/each_pair.rb b/sandbox/each_pair.rb",
      "new file mode 100644",
      "index 0000000..0de8ec4",
      "--- /dev/null",
      "+++ b/sandbox/each_pair.rb",
      "@@ -0,0 +1,8 @@",
      "+",
      "+class Array",
      "+    def each_pair",
      "+        (0..(self.length-1)).each do |i|",
      "+          yield self[i], self[i+1]",
      "+        end",
      "+    end",
      "+end ",
      "diff --git a/sandbox/gapper.rb b/sandbox/gapper.rb",
      "index 6cf082b..08e1893 100644",
      "--- a/sandbox/gapper.rb",
      "+++ b/sandbox/gapper.rb",
      "@@ -12,10 +12,3 @@ def gapper(lights, from, to, secs_per_gap)",
      "   gaps",
      " end",
      " ",
      "-class Array",
      "-    def each_pair",
      "-        (0..(self.length-1)).each do |i|",
      "-          yield self[i], self[i+1]",
      "-        end",
      "-    end",
      "-end ",
      "diff --git a/sandbox/test_each_pair.rb b/sandbox/test_each_pair.rb",
      "new file mode 100644",
      "index 0000000..e18f2ce",
      "--- /dev/null",
      "+++ b/sandbox/test_each_pair.rb",
      "@@ -0,0 +1,13 @@",
      "+require 'each_pair'",
      "+require 'test/unit'",
      "+",
      "+class TestEachPair < Test::Unit::TestCase",
      "+",
      "+  test \"each_pair\"",
      "+",
      "+    [2,4,5,6].each_pair do |a,b| p a; p b; end",
      "+",
      "+    assert_equal expected, gapper(lights, from, to, secs_per_gap)",
      "+  end",
      "+",
      "+end",
      "diff --git a/sandbox/test_gapper.rb b/sandbox/test_gapper.rb",
      "index 426dcea..0d9cefb 100644",
      "--- a/sandbox/test_gapper.rb",
      "+++ b/sandbox/test_gapper.rb",
      "@@ -20,8 +20,6 @@ class TestGapper < Test::Unit::TestCase",
      "       [],  # [50:38 -> 50:43] +20 ",
      "     ]    ",
      " ",
      "-    [2,4,5,6].each_pair do |a,b| p a; p b; end",
      "-",
      "     assert_equal expected, gapper(lights, from, to, secs_per_gap)",
      "   end",
      " "
    ].join("\n")

    diffs = GitDiff::GitDiffParser.new(diff_lines).parse_all
    sandbox_name = 'b/sandbox/gapper.rb'
    diff = diffs[sandbox_name]
    expected_diff =
    {
        :prefix_lines =>
          [
            'diff --git a/sandbox/gapper.rb b/sandbox/gapper.rb',
            'index 6cf082b..08e1893 100644',
          ],
        :was_filename => 'a/sandbox/gapper.rb',
        :now_filename => 'b/sandbox/gapper.rb',
        :chunks =>
          [
            {
              :range =>
              {
                :was => { :start_line => 12, :size => 10 },
                :now => { :start_line => 12, :size => 3 },
              },
              :before_lines => [ '  gaps', 'end', '' ],
              :sections =>
              [
                {
                  :deleted_lines =>
                    [
                      "class Array",
                      "    def each_pair",
                      "        (0..(self.length-1)).each do |i|",
                      "          yield self[i], self[i+1]",
                      "        end",
                      "    end",
                      "end "
                    ],
                  :added_lines   => [ ],
                  :after_lines => [ ]
                }, # section
              ] # sections
            } # chunk
          ] # chunks
    }
    assert_equal expected_diff, diff

    md = %r|^(.)/sandbox/(.*)|.match(sandbox_name)
    name = md[2]
    assert 'gapper.rb', name

    source_lines = visible_files[name]

    split_up = source_lines.split("\n")
    builder = GitDiff::GitDiffBuilder.new()
    view = builder.build(diff, split_up)
    nils = view.select { |one| one[:line].nil? }
    refute_equal [ ], nils

    # OK. And after all that the problem is the split.
    assert_equal [ ], "\n\n".split("\n")

    # that's not what I want
    # I want "\n\n" --> [ "", "" ]
    # So...
    assert_equal [ "", "" ], "\n\n".split(/(\n)/).select { |line| line != "\n" }

    # And to double check...

    split_up = source_lines.split(/(\n)/).select { |line| line != "\n"}
    builder = GitDiff::GitDiffBuilder.new()
    view = builder.build(diff, split_up)
    nils = view.select { |one| one[:line] == "\n" }
    assert_equal [ ], nils

  end

end
