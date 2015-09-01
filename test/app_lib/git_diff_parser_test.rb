#!/bin/bash ../test_wrapper.sh

require_relative './app_lib_test_base'

class GitDiffParserTests < AppLibTestBase

  include GitDiff

  test 'lines are split' do
    lines = [ 'a', 'b' ]
    assert_equal lines, GitDiffParser.new(lines.join("\n")).lines
  end

  #-----------------------------------------------------

  test 'parse diff for filename ending in tab removes the tab' do
    was_line =  '--- a/sandbox/ab cd'
    assert_equal 'a/sandbox/ab cd',
      GitDiffParser.new(was_line + "\t").parse_was_filename
  end

  #-----------------------------------------------------

  test 'parse diff for filename with space in its name' do
    was_line =  '--- a/sandbox/ab cd'
    assert_equal 'a/sandbox/ab cd',
      GitDiffParser.new(was_line).parse_was_filename
  end

  #-----------------------------------------------------

  test 'parse diff for deleted file' do
    was_line =  '--- a/sandbox/xxx'
    assert_equal 'a/sandbox/xxx',
      GitDiffParser.new(was_line).parse_was_filename

    now_line = '+++ /dev/null'
    assert_equal '/dev/null',
      GitDiffParser.new(now_line).parse_now_filename
  end

  #-----------------------------------------------------

  test 'parse diff for new file' do
    was_line =  '--- /dev/null'
    assert_equal '/dev/null',
      GitDiffParser.new(was_line).parse_was_filename

    now_line = '+++ b/sandbox/untitled_6TJ'
    assert_equal 'b/sandbox/untitled_6TJ',
      GitDiffParser.new(now_line).parse_now_filename
  end

  #-----------------------------------------------------

  test 'parse diff containing quoted filename with backslash' do
    filename = '"\\\\was"'
    expected = '\\was'
    actual = GitDiffParser.new('').unescaped(filename)
    assert_equal expected, actual
  end

  #-----------------------------------------------------

  test 'parse diff containing filename with backslash' do

    lines =
    [
      'diff --git "a/sandbox/\\\\was_newfile_FIU" "b/sandbox/\\\\was_newfile_FIU"',
      'deleted file mode 100644',
      'index 21984c7..0000000',
      '--- "a/sandbox/\\\\was_newfile_FIU"',
      '+++ /dev/null',
      '@@ -1 +0,0 @@',
      '-Please rename me!',
      '\\ No newline at end of file'
    ].join("\n")

    expected =
    {
      'a/sandbox/\\was_newfile_FIU' => # <-- single backslash
      {
        :prefix_lines =>
        [
            'diff --git "a/sandbox/\\\\was_newfile_FIU" "b/sandbox/\\\\was_newfile_FIU"',
            'deleted file mode 100644',
            'index 21984c7..0000000',
        ],
        :was_filename => 'a/sandbox/\\was_newfile_FIU', # <-- single backslash
        :now_filename => '/dev/null',
        :chunks       =>
        [
          {
            :range =>
            {
              :now => { :size => 0, :start_line => 0 },
              :was => { :size => 1, :start_line => 1 }
            },
            :sections =>
            [
              {
                :deleted_lines => [ 'Please rename me!' ],
                :added_lines   => [ ],
                :after_lines   => [ ]
              }
            ],
            :before_lines => [ ]
          }
        ]
      }
    }

    parser = GitDiffParser.new(lines)
    actual = parser.parse_all
    assert_equal expected, actual

  end

  #-----------------------------------------------------

  test 'parse diff deleted file' do

    lines =
    [
      'diff --git a/sandbox/original b/sandbox/original',
      'deleted file mode 100644',
      'index e69de29..0000000'
    ].join("\n")

    expected =
    {
      'a/sandbox/original' =>
      {
        :prefix_lines =>
        [
            'diff --git a/sandbox/original b/sandbox/original',
            'deleted file mode 100644',
            'index e69de29..0000000',
        ],
        :was_filename => 'a/sandbox/original',
        :now_filename => '/dev/null',
        :chunks       => [ ]
      }
    }

    parser = GitDiffParser.new(lines)
    actual = parser.parse_all
    assert_equal expected, actual

  end

  #-----------------------------------------------------

  test 'parse another diff-form of a deleted file' do

    lines =
    [
      'diff --git a/sandbox/untitled.rb b/sandbox/untitled.rb',
      'deleted file mode 100644',
      'index 5c4b3ab..0000000',
      '--- a/sandbox/untitled.rb',
      '+++ /dev/null',
      '@@ -1,3 +0,0 @@',
      '-def answer',
      '-  42',
      '-end'
    ].join("\n")

    expected =
    {
      'a/sandbox/untitled.rb' =>
      {
        :prefix_lines =>
        [
            'diff --git a/sandbox/untitled.rb b/sandbox/untitled.rb',
            'deleted file mode 100644',
            'index 5c4b3ab..0000000',
        ],
        :was_filename => 'a/sandbox/untitled.rb',
        :now_filename => '/dev/null',
        :chunks =>
        [
          {
            :range =>
            {
              :was => { :start_line => 1, :size       => 3 },
              :now => { :start_line => 0, :size       => 0 }
            },
            :before_lines => [ ],
            :sections     =>
            [
              {
              :deleted_lines => [ 'def answer', '  42', 'end'],
              :added_lines   => [ ],
              :after_lines   => [ ]
              }
            ]
          }
        ]
      }
    }

    parser = GitDiffParser.new(lines)
    actual = parser.parse_all
    assert_equal expected, actual

    assert_equal [ 'def answer','  42', 'end'],
      actual['a/sandbox/untitled.rb'][:chunks][0][:sections][0][:deleted_lines]

    md = %r|^(.)/sandbox/(.*)|.match('a/sandbox/untitled.rb')
    assert_not_nil md
    assert_equal 'a', md[1]
    filename = md[2]
    assert_equal 'untitled.rb', filename

  end

  #-----------------------------------------------------

  test 'parse diff for renamed but unchanged file and newname is quoted' do

    lines =
    [
      'diff --git "a/sandbox/was_\\\\wa s_newfile_FIU" "b/sandbox/\\\\was_newfile_FIU"',
      'similarity index 100%',
      'rename from "sandbox/was_\\\\wa s_newfile_FIU"',
      'rename to "sandbox/\\\\was_newfile_FIU"'
    ].join("\n")

    expected =
    {
      'b/sandbox/\\was_newfile_FIU' => # <-- single backslash
      {
        :prefix_lines =>
        [
            'diff --git "a/sandbox/was_\\\\wa s_newfile_FIU" "b/sandbox/\\\\was_newfile_FIU"',
            'similarity index 100%',
            'rename from "sandbox/was_\\\\wa s_newfile_FIU"',
            'rename to "sandbox/\\\\was_newfile_FIU"',
        ],
        :was_filename => 'a/sandbox/was_\\wa s_newfile_FIU', # <-- single backslash
        :now_filename => 'b/sandbox/\\was_newfile_FIU', # <-- single backslash
        :chunks       => [ ]
      }
    }

    parser = GitDiffParser.new(lines)
    actual = parser.parse_all
    assert_equal expected, actual

  end

  #-----------------------------------------------------

  test 'parse diff for renamed but unchanged file' do

    lines =
    [
      'diff --git a/sandbox/oldname b/sandbox/newname',
      'similarity index 100%',
      'rename from sandbox/oldname',
      'rename to sandbox/newname'
    ].join("\n")

    expected =
    {
      'b/sandbox/newname' =>
      {
        :prefix_lines =>
        [
            'diff --git a/sandbox/oldname b/sandbox/newname',
            'similarity index 100%',
            'rename from sandbox/oldname',
            'rename to sandbox/newname',
        ],
        :was_filename => 'a/sandbox/oldname',
        :now_filename => 'b/sandbox/newname',
        :chunks       => [ ]
      }
    }

    parser = GitDiffParser.new(lines)
    actual = parser.parse_all
    assert_equal expected, actual

  end

  #-----------------------------------------------------

  test "parse diff for renamed and changed file" do

    lines =
    [
      'diff --git a/sandbox/instructions b/sandbox/instructions_new',
      'similarity index 87%',
      'rename from sandbox/instructions',
      'rename to sandbox/instructions_new',
      'index e747436..83ec100 100644',
      '--- a/sandbox/instructions',
      '+++ b/sandbox/instructions_new',
      '@@ -6,4 +6,4 @@ For example, the potential anagrams of "biro" are',
      ' biro bior brio broi boir bori',
      ' ibro ibor irbo irob iobr iorb',
      ' rbio rboi ribo riob roib robi',
      '-obir obri oibr oirb orbi orib',
      '+obir obri oibr oirb orbi oribx'
    ].join("\n")

    expected_diff =
    {
        :prefix_lines =>
          [
            'diff --git a/sandbox/instructions b/sandbox/instructions_new',
            'similarity index 87%',
            'rename from sandbox/instructions',
            'rename to sandbox/instructions_new',
            'index e747436..83ec100 100644'
          ],
          :was_filename => 'a/sandbox/instructions',
          :now_filename => 'b/sandbox/instructions_new',
        :chunks =>
          [
            {
              :range =>
              {
                :was => { :start_line => 6, :size => 4 },
                :now => { :start_line => 6, :size => 4 },
              },
              :before_lines =>
                [
                  'biro bior brio broi boir bori',
                  'ibro ibor irbo irob iobr iorb',
                  'rbio rboi ribo riob roib robi'
                ],
              :sections =>
              [
                {
                  :deleted_lines => [ 'obir obri oibr oirb orbi orib' ],
                  :added_lines   => [ 'obir obri oibr oirb orbi oribx' ],
                  :after_lines   => [ ]
                }, # section
              ] # sections
            } # chunk
          ] # chunks
    }

    expected = { 'b/sandbox/instructions_new' => expected_diff }
    parser = GitDiffParser.new(lines)
    actual = parser.parse_all
    assert_equal expected, actual

  end

  #-----------------------------------------------------

  test 'parse diffs for two files' do

    lines =
    [
      'diff --git a/sandbox/lines b/sandbox/lines',
      'index 896ddd8..2c8d1b8 100644',
      '--- a/sandbox/lines',
      '+++ b/sandbox/lines',
      '@@ -1,7 +1,7 @@',
      ' aaa',
      ' bbb',
      ' ccc',
      '-ddd',
      '+eee',
      ' fff',
      ' ggg',
      ' hhh',
      'diff --git a/sandbox/other b/sandbox/other',
      'index cf0389a..b28bf03 100644',
      '--- a/sandbox/other',
      '+++ b/sandbox/other',
      '@@ -1,6 +1,6 @@',
      ' AAA',
      ' BBB',
      '-CCC',
      '-DDD',
      '+EEE',
      '+FFF',
      ' GGG',
      ' HHH',
      "\\ No newline at end of file"
    ].join("\n")

    expected_diff_1 =
    {
        :prefix_lines =>
          [
            'diff --git a/sandbox/lines b/sandbox/lines',
            'index 896ddd8..2c8d1b8 100644'
          ],
        :was_filename => 'a/sandbox/lines',
        :now_filename => 'b/sandbox/lines',
        :chunks       =>
          [
            {
              :range =>
              {
                :was => { :start_line => 1, :size => 7 },
                :now => { :start_line => 1, :size => 7 },
              },
              :before_lines => [ 'aaa', 'bbb', 'ccc'],
              :sections     =>
              [
                {
                  :deleted_lines => [ 'ddd' ],
                  :added_lines   => [ 'eee' ],
                  :after_lines   => [ 'fff', 'ggg', 'hhh' ]
                }, # section
              ] # sections
            } # chunk
          ] # chunks
    } # expected

    expected_diff_2 =
    {
        :prefix_lines =>
          [
            'diff --git a/sandbox/other b/sandbox/other',
            'index cf0389a..b28bf03 100644'
          ],
        :was_filename => 'a/sandbox/other',
        :now_filename => 'b/sandbox/other',
        :chunks =>
          [
            {
              :range =>
              {
                :was => { :start_line => 1, :size => 6 },
                :now => { :start_line => 1, :size => 6 },
              },
              :before_lines => [ 'AAA', 'BBB' ],
              :sections     =>
              [
                {
                  :deleted_lines => [ 'CCC', 'DDD' ],
                  :added_lines   => [ 'EEE', 'FFF' ],
                  :after_lines   => [ 'GGG', 'HHH' ]
                }, # section
              ] # sections
            } # chunk
          ] # chunks
    } # expected

    expected =
    {
      'b/sandbox/lines' => expected_diff_1,
      'b/sandbox/other' => expected_diff_2
    }

    parser = GitDiffParser.new(lines)
    assert_equal expected, parser.parse_all

  end

  #-----------------------------------------------------

  test 'parse range was-size and now-size defaulted' do
    lines = '@@ -3 +5 @@'
    expected =
    {
      :was => { :start_line => 3, :size => 1 },
      :now => { :start_line => 5, :size => 1 },
    }
    assert_equal expected, GitDiffParser.new(lines).parse_range
  end

  #-----------------------------------------------------

  test 'parse range was-size defaulted' do
    lines = '@@ -3 +5,9 @@'
    expected =
    {
      :was => { :start_line => 3, :size => 1 },
      :now => { :start_line => 5, :size => 9 },
    }
    assert_equal expected, GitDiffParser.new(lines).parse_range
  end

  #-----------------------------------------------------

  test 'parse range now-size defaulted' do
    lines = '@@ -3,4 +5 @@'
    expected =
    {
      :was => { :start_line => 3, :size => 4 },
      :now => { :start_line => 5, :size => 1 },
    }
    assert_equal expected, GitDiffParser.new(lines).parse_range
  end

  #-----------------------------------------------------

  test 'parse range nothing defaulted' do
    lines = '@@ -3,4 +5,6 @@'
    expected =
    {
      :was => { :start_line => 3, :size => 4 },
      :now => { :start_line => 5, :size => 6 },
    }
    assert_equal expected, GitDiffParser.new(lines).parse_range
  end

  #-----------------------------------------------------

  test 'parse no-newline-at-eof without leading backslash' do
    lines = ' No newline at eof'
    parser = GitDiffParser.new(lines)

    assert_equal 0, parser.n
    parser.parse_newline_at_eof
    assert_equal 0, parser.n
  end

  #-----------------------------------------------------

  test 'parse no-newline-at-eof with leading backslash' do
    lines = '\\ No newline at end of file'
    parser = GitDiffParser.new(lines)

    assert_equal 0, parser.n
    parser.parse_newline_at_eof
    assert_equal 1, parser.n
  end

  #-----------------------------------------------------

  test 'two chunks with no newline at end of file' do

    lines =
    [
      'diff --git a/sandbox/lines b/sandbox/lines',
      'index b1a30d9..7fa9727 100644',
      '--- a/sandbox/lines',
      '+++ b/sandbox/lines',
      '@@ -1,5 +1,5 @@',
      ' AAA',
      '-BBB',
      '+CCC',
      ' DDD',
      ' EEE',
      ' FFF',
      '@@ -8,6 +8,6 @@',
      ' PPP',
      ' QQQ',
      ' RRR',
      '-SSS',
      '+TTT',
      ' UUU',
      ' VVV',
      "\\ No newline at end of file"
    ].join("\n")

    expected =
    {
        :prefix_lines =>
          [
            'diff --git a/sandbox/lines b/sandbox/lines',
            'index b1a30d9..7fa9727 100644'
          ],
        :was_filename => 'a/sandbox/lines',
        :now_filename => 'b/sandbox/lines',
        :chunks       =>
          [
            {
              :range =>
              {
                :was => { :start_line => 1, :size => 5 },
                :now => { :start_line => 1, :size => 5 },
              },
              :before_lines => [ 'AAA' ],
              :sections     =>
              [
                {
                  :deleted_lines => [ 'BBB' ],
                  :added_lines   => [ 'CCC' ],
                  :after_lines   => [ 'DDD', 'EEE', 'FFF' ]
                }, # section
              ] # sections
            }, # chunk
            {
              :range =>
              {
                :was => { :start_line => 8, :size => 6 },
                :now => { :start_line => 8, :size => 6 },
              },
              :before_lines => [ 'PPP', 'QQQ', 'RRR' ],
              :sections     =>
              [
                {
                  :deleted_lines => [ 'SSS' ],
                  :added_lines   => [ 'TTT' ],
                  :after_lines   => [ 'UUU', 'VVV' ]
                }, # section
              ] # sections
            }
          ] # chunks
    } # expected

    assert_equal expected, GitDiffParser.new(lines).parse_one

  end

  #-----------------------------------------------------

  test 'diff one chunk one section' do

    lines =
    [
      '@@ -1,4 +1,4 @@',
      '-AAA',
      '+BBB',
      ' CCC',
      ' DDD',
      ' EEE'
    ].join("\n")

    expected =
      {
        :range =>
        {
          :was => { :start_line => 1, :size => 4 },
          :now => { :start_line => 1, :size => 4 },
        },
        :before_lines => [ ],
        :sections     =>
        [
          {
            :deleted_lines => [ 'AAA' ],
            :added_lines   => [ 'BBB' ],
            :after_lines   => [ 'CCC', 'DDD', 'EEE' ]
          }, # section
        ] # sections
      } # chunk

    assert_equal expected,
      GitDiffParser.new(lines).parse_chunk_one
  end

  #-----------------------------------------------------

  test 'diff one chunk two sections' do

    lines =
    [
      '@@ -1,8 +1,8 @@',
      ' AAA',
      ' BBB',
      '-CCC',
      '+DDD',
      ' EEE',
      '-FFF',
      '+GGG',
      ' HHH',
      ' JJJ',
      ' KKK'
    ].join("\n")

    expected =
      [
        {
          :range =>
          {
            :was => { :start_line => 1, :size => 8 },
            :now => { :start_line => 1, :size => 8 },
          },
          :before_lines => [ 'AAA', 'BBB' ],
          :sections     =>
          [
            {
              :deleted_lines => [ 'CCC' ],
              :added_lines   => [ 'DDD' ],
              :after_lines   => [ 'EEE' ]
            }, # section
            {
              :deleted_lines => [ 'FFF' ],
              :added_lines   => [ 'GGG' ],
              :after_lines   => [ 'HHH', 'JJJ', 'KKK' ]
            }, # section
          ] # sections
        } # chunk
      ] # chunks
    assert_equal expected, GitDiffParser.new(lines).parse_chunk_all

  end

  #-----------------------------------------------------

  test 'standard diff' do

    lines =
    [
      'diff --git a/sandbox/gapper.rb b/sandbox/gapper.rb',
      'index 26bc41b..8a5b0b7 100644',
      '--- a/sandbox/gapper.rb',
      '+++ b/sandbox/gapper.rb',
      '@@ -4,7 +5,8 @@ COMMENT',
      ' aaa',
      ' bbb',
      ' ',
      '-XXX',
      '+YYY',
      '+ZZZ',
      ' ccc',
      ' ddd',
      ' eee'
    ].join("\n")

    expected =
    {
      :prefix_lines =>
      [
        'diff --git a/sandbox/gapper.rb b/sandbox/gapper.rb',
        'index 26bc41b..8a5b0b7 100644'
      ],
      :was_filename => 'a/sandbox/gapper.rb',
      :now_filename => 'b/sandbox/gapper.rb',
      :chunks       =>
      [
        {
          :range =>
          {
            :was => { :start_line => 4, :size => 7 },
            :now => { :start_line => 5, :size => 8 },
          },
          :before_lines => [ 'aaa', 'bbb', '' ],
          :sections =>
          [
            { :deleted_lines => [ 'XXX' ],
              :added_lines => [ 'YYY', 'ZZZ' ],
              :after_lines => [ 'ccc', 'ddd', 'eee' ]
            }
          ]
        }
      ]
    }
    assert_equal expected, GitDiffParser.new(lines).parse_one

  end

  #-----------------------------------------------------

  test 'find copies harder finds a rename' do

    lines =
    [
      'diff --git a/sandbox/oldname b/sandbox/newname',
      'similarity index 99%',
      'rename from sandbox/oldname',
      'rename to sandbox/newname',
      'index afcb4df..c0f407c 100644'
    ]

    assert_equal lines,
      GitDiffParser.new(lines.join("\n")).parse_prefix_lines
  end

  #-----------------------------------------------------

  test 'not an deleted line' do

    lines =
    [
      '+p Timw.now',
      '+p Time.now'
    ].join("\n")

    expected = [ ]
    assert_equal expected,
      GitDiffParser.new(lines).parse_deleted_lines
  end

  #-----------------------------------------------------

  test 'not an added line' do

    lines =
    [
      ' p Timw.now',
      ' p Time.now'
    ].join("\n")

    expected = [ ]
    assert_equal expected,
      GitDiffParser.new(lines).parse_added_lines
  end

  #-----------------------------------------------------

  test 'single deleted line' do

    lines =
    [
      '-p Timw.now',
      '+p Time.now'
    ].join("\n")

    expected =
      [
        'p Timw.now'
      ]
    assert_equal expected,
      GitDiffParser.new(lines).parse_deleted_lines
  end

  #-----------------------------------------------------

  test 'single added line' do

    lines =
    [
    '+p Time.now',
    ' common line'
    ].join("\n")

    expected =
      [
        'p Time.now'
      ]
    assert_equal expected,
      GitDiffParser.new(lines).parse_added_lines
  end

  #-----------------------------------------------------

  test 'single deleted line with trailing newline-at-eof' do

    lines =
    [
      '-p Timw.now',
      "\\ No newline at end of file'"
    ].join("\n")

    expected =
      [
        'p Timw.now',
      ]
    assert_equal expected,
      GitDiffParser.new(lines).parse_deleted_lines
  end

  #-----------------------------------------------------

  test 'single added line with trailing newline-at-eof' do

    lines =
    [
      '+p Timw.now',
      "\\ No newline at end of file'"
    ].join("\n")

    expected =
      [
        'p Timw.now',
      ]
    assert_equal expected,
      GitDiffParser.new(lines).parse_added_lines
  end

  #-----------------------------------------------------

  test 'two deleted lines' do

    lines =
    [
      '-p Timw.now',
      '-p Time.now'
    ].join("\n")

    expected =
      [
        'p Timw.now',
        'p Time.now'
      ]
    assert_equal expected,
      GitDiffParser.new(lines).parse_deleted_lines
  end

  #-----------------------------------------------------

  test 'two added lines' do

    lines =
    [
      '+p Timw.now',
      '+p Time.now'
    ].join("\n")

    expected =
      [
        'p Timw.now',
        'p Time.now'
      ]
    assert_equal expected,
    GitDiffParser.new(lines).parse_added_lines
  end

  #-----------------------------------------------------

  test 'two deleted lines with trailing newline-at-eof' do

    lines =
    [
      '-p Timw.now',
      '-p Time.now',
      "\\ No newline at end of file"
    ].join("\n")

    expected =
      [
        'p Timw.now',
        'p Time.now'
      ]
    assert_equal expected,
      GitDiffParser.new(lines).parse_deleted_lines
  end

  #-----------------------------------------------------

  test 'two added lines with trailing newline-at-eof' do

    lines =
    [
      '+p Timw.now',
      '+p Time.now',
      "\\ No newline at end of file"
    ].join("\n")

    expected =
      [
        'p Timw.now',
        'p Time.now'
      ]
    assert_equal expected,
      GitDiffParser.new(lines).parse_added_lines
  end

  #-----------------------------------------------------

  test 'diff two chunks' do

    lines =
    [
      'diff --git a/sandbox/test_gapper.rb b/sandbox/test_gapper.rb',
      'index 4d3ca1b..61e88f0 100644',
      '--- a/sandbox/test_gapper.rb',
      '+++ b/sandbox/test_gapper.rb',
      '@@ -9,4 +9,3 @@ class TestGapper < Test::Unit::TestCase',
      '-p Timw.now',
      '+p Time.now',
      "\\ No newline at end of file",
      '@@ -19,4 +19,3 @@ class TestGapper < Test::Unit::TestCase',
      '-q Timw.now',
      '+q Time.now'
    ].join("\n")

    expected =
    {
        :prefix_lines =>
          [
            'diff --git a/sandbox/test_gapper.rb b/sandbox/test_gapper.rb',
            'index 4d3ca1b..61e88f0 100644'
          ],
        :was_filename => 'a/sandbox/test_gapper.rb',
        :now_filename => 'b/sandbox/test_gapper.rb',
        :chunks       =>
          [
            {
              :range =>
              {
                :was => { :start_line => 9, :size => 4 },
                :now => { :start_line => 9, :size => 3 },
              },
              :before_lines => [ ],
              :sections     =>
              [
                { :deleted_lines => [ 'p Timw.now' ],
                  :added_lines   => [ 'p Time.now' ],
                  :after_lines   => [ ]
                }
              ]
            },
            {
              :range =>
              {
                :was => { :start_line => 19, :size => 4 },
                :now => { :start_line => 19, :size => 3 },
              },
              :before_lines => [ ],
              :sections     =>
              [
                {
                  :deleted_lines => [ 'q Timw.now' ],
                  :added_lines   => [ 'q Time.now' ],
                  :after_lines   => [ ]
                }
              ]
            }
          ]
    }
    assert_equal expected, GitDiffParser.new(lines).parse_one

  end

  #-----------------------------------------------------

  test 'when diffs are one line apart' do

    lines =
    [
      'diff --git a/sandbox/lines b/sandbox/lines',
      'index 5ed4618..c47ec44 100644',
      '--- a/sandbox/lines',
      '+++ b/sandbox/lines',
      '@@ -5,9 +5,9 @@',
      ' AAA',
      ' BBB',
      ' CCC',
      '-DDD',
      '+EEE',
      ' FFF',
      '-GGG',
      '+HHH',
      ' JJJ',
      ' KKK',
      ' LLL'
    ].join("\n")

    expected =
    {
        :prefix_lines =>
          [
            'diff --git a/sandbox/lines b/sandbox/lines',
            'index 5ed4618..c47ec44 100644'
          ],
        :was_filename => 'a/sandbox/lines',
        :now_filename => 'b/sandbox/lines',
        :chunks       =>
          [
            {
              :range =>
              {
                :was => { :start_line => 5, :size => 9 },
                :now => { :start_line => 5, :size => 9 },
              },
              :before_lines => [ 'AAA', 'BBB', 'CCC' ],
              :sections     =>
              [
                {
                  :deleted_lines => [ 'DDD' ],
                  :added_lines   => [ 'EEE' ],
                  :after_lines   => [ 'FFF' ]
                },
                {
                  :deleted_lines => [ 'GGG' ],
                  :added_lines   => [ 'HHH' ],
                  :after_lines   => [ 'JJJ', 'KKK', 'LLL' ]
                } # section
              ] # sections
            } # chunk
          ] # chunks
    } # expected
    assert_equal expected, GitDiffParser.new(lines).parse_one

  end

  #-----------------------------------------------------

  test 'when diffs are 2 lines apart' do

    lines =
    [
      'diff --git a/sandbox/lines b/sandbox/lines',
      'index 5ed4618..aad3f67 100644',
      '--- a/sandbox/lines',
      '+++ b/sandbox/lines',
      '@@ -5,10 +5,10 @@',
      ' AAA',
      ' BBB',
      ' CCC',
      '-DDD',
      '+EEE',
      ' FFF',
      ' GGG',
      '-HHH',
      '+JJJ',
      ' KKK',
      ' LLL',
      ' MMM'
    ].join("\n")

    expected =
    {
        :prefix_lines =>
          [
            'diff --git a/sandbox/lines b/sandbox/lines',
            'index 5ed4618..aad3f67 100644'
          ],
        :was_filename => 'a/sandbox/lines',
        :now_filename => 'b/sandbox/lines',
        :chunks       =>
          [
            {
              :range =>
              {
                :was => { :start_line => 5, :size => 10 },
                :now => { :start_line => 5, :size => 10 },
              },
              :before_lines => [ 'AAA', 'BBB', 'CCC' ],
              :sections     =>
              [
                {
                  :deleted_lines => [ 'DDD' ],
                  :added_lines   => [ 'EEE' ],
                  :after_lines   => [ 'FFF', 'GGG' ]
                },
                {
                  :deleted_lines => [ 'HHH' ],
                  :added_lines   => [ 'JJJ' ],
                  :after_lines   => [ 'KKK', 'LLL', 'MMM' ]
                } # section
              ] # sections
            } # chunk
          ] # chunks
    } # expected
    assert_equal expected, GitDiffParser.new(lines).parse_one

  end

  #-----------------------------------------------------

  test 'when there is less than 7 unchanged lines' +
       'between 2 changed lines ' +
       'they are merged into one chunk' do

    lines =
    [
      'diff --git a/sandbox/lines b/sandbox/lines',
      'index 5ed4618..33d0e05 100644',
      '--- a/sandbox/lines',
      '+++ b/sandbox/lines',
      '@@ -5,14 +5,14 @@',
      ' AAA',
      ' BBB',
      ' CCC',
      '-DDD',
      '+EEE',
      ' FFF',
      ' GGG',
      ' HHH',
      ' JJJ',
      ' KKK',
      ' LLL',
      '-MMM',
      '+NNN',
      ' OOO',
      ' PPP'
    ].join("\n")

    expected =
    {
        :prefix_lines =>
          [
            "diff --git a/sandbox/lines b/sandbox/lines",
            "index 5ed4618..33d0e05 100644"
          ],
        :was_filename => 'a/sandbox/lines',
        :now_filename => 'b/sandbox/lines',
        :chunks       =>
          [
            {
              :range =>
              {
                :was => { :start_line => 5, :size => 14 },
                :now => { :start_line => 5, :size => 14 },
              },
              :before_lines => [ 'AAA', 'BBB', 'CCC' ],
              :sections     =>
              [
                {
                  :deleted_lines => [ 'DDD' ],
                  :added_lines   => [ 'EEE' ],
                  :after_lines   => [ 'FFF', 'GGG', 'HHH', 'JJJ', 'KKK', 'LLL' ]
                },
                {
                  :deleted_lines => [ 'MMM' ],
                  :added_lines   => [ 'NNN' ],
                  :after_lines   => [ 'OOO', 'PPP' ]
                } # section
              ] # sections
            } # chunk
          ] # chunks
    } # expected
    assert_equal expected, GitDiffParser.new(lines).parse_one
  end

  #-----------------------------------------------------

  test '7 unchanged lines between two changed lines' +
       'creates two chunks' do

    lines =
    [
      'diff --git a/sandbox/lines b/sandbox/lines',
      'index 5ed4618..e78c888 100644',
      '--- a/sandbox/lines',
      '+++ b/sandbox/lines',
      '@@ -5,7 +5,7 @@',
      ' AAA',
      ' BBB',
      ' CCC',
      '-DDD',
      '+EEE',
      ' FFF',
      ' GGG',
      ' HHH',
      '@@ -13,7 +13,7 @@',
      ' QQQ',
      ' RRR',
      ' SSS',
      '-TTT',
      '+UUU',
      ' VVV',
      ' WWW',
      ' XXX'
    ].join("\n")

    expected =
    {
        :prefix_lines =>
          [
            'diff --git a/sandbox/lines b/sandbox/lines',
            'index 5ed4618..e78c888 100644'
          ],
        :was_filename => 'a/sandbox/lines',
        :now_filename => 'b/sandbox/lines',
        :chunks       =>
          [
            {
              :range =>
              {
                :was => { :start_line => 5, :size => 7 },
                :now => { :start_line => 5, :size => 7 },
              },
              :before_lines => [ 'AAA', 'BBB', 'CCC' ],
              :sections     =>
              [
                {
                  :deleted_lines => [ 'DDD' ],
                  :added_lines   => [ 'EEE' ],
                  :after_lines   => [ 'FFF', 'GGG', 'HHH' ]
                }
              ]
            },
            {
              :range =>
              {
                :was => { :start_line => 13, :size => 7 },
                :now => { :start_line => 13, :size => 7 },
              },
              :before_lines => [ 'QQQ', 'RRR', 'SSS' ],
              :sections     =>
              [
                {
                  :deleted_lines => [ 'TTT' ],
                  :added_lines   => [ 'UUU' ],
                  :after_lines   => [ 'VVV', 'WWW', 'XXX' ]
                } # section
              ] # sections
            } # chunk
          ] # chunks
    } # expected
    assert_equal expected, GitDiffParser.new(lines).parse_one

  end

  #-----------------------------------------------------

  test 'no-newline-at-end-of-file line at end of ' +
       'common section is gobbled' do

    # James Grenning has built his own cyber-dojo server
    # which he uses for training. He noticed that a file
    # called CircularBufferTests.cpp
    # changed between two traffic-lights but the diff-view
    # was not displaying the diff. He sent me a zip of the
    # avatars git repository and I confirmed that
    #   git diff 8 9 sandbox/CircularBufferTests.cpp
    # produced the following output

    lines =
    [
      'diff --git a/sandbox/CircularBufferTest.cpp b/sandbox/CircularBufferTest.cpp',
      'index 0ddb952..a397f48 100644',
      '--- a/sandbox/CircularBufferTest.cpp',
      '+++ b/sandbox/CircularBufferTest.cpp',
      '@@ -35,3 +35,8 @@ TEST(CircularBuffer, EmptyAfterCreation)',
      ' {',
      '     CHECK_TRUE(CircularBuffer_IsEmpty(buffer));',
      ' }',
      '\\ No newline at end of file',
      '+',
      '+TEST(CircularBuffer, NotFullAfterCreation)',
      '+{',
      '+    CHECK_FALSE(CircularBuffer_IsFull(buffer));',
      '+}',
      '\\ No newline at end of file'
    ].join("\n")

    expected =
    {
        :prefix_lines =>
          [
            'diff --git a/sandbox/CircularBufferTest.cpp b/sandbox/CircularBufferTest.cpp',
            'index 0ddb952..a397f48 100644'
          ],
        :was_filename => 'a/sandbox/CircularBufferTest.cpp',
        :now_filename => 'b/sandbox/CircularBufferTest.cpp',
        :chunks       =>
          [
            {
              :range =>
              {
                :was => { :start_line => 35, :size => 3 },
                :now => { :start_line => 35, :size => 8 },
              },
              :before_lines =>
              [
                '{',
                '    CHECK_TRUE(CircularBuffer_IsEmpty(buffer));',
                '}'
              ],
              :sections =>
              [
                {
                  :deleted_lines => [ ],
                  :added_lines   =>
                  [
                    '',
                    'TEST(CircularBuffer, NotFullAfterCreation)',
                    '{',
                    '    CHECK_FALSE(CircularBuffer_IsFull(buffer));',
                    '}'
                  ],
                  :after_lines => [ ]
                }
              ]
            }
          ] # chunks
    } # expected

    assert_equal expected, GitDiffParser.new(lines).parse_one
  end

end
