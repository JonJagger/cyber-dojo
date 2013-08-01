require File.dirname(__FILE__) + '/../test_helper'
require 'GitDiff'
require 'GitDiffParser'

class TrapDiffBugTests < ActionController::TestCase
  
  include GitDiff
  
  test "real dojo from Chennai Cisco training 31 July 2013 that failed a diff" do
    
    # this was extracted using irb and
    #    >cmd = 'cd elephant; git show 11:manifest.rb'
    #    >visible_files = IO::popen(cmd).read
    visible_files = eval "{\"untitled.c\"=>\"#include \\\"untitled.h\\\"\\n#include <string.h>\\n\\nstruct roman_string to_roman(int n)\\n{\\n    struct roman_string result;\\n\\n    while (n > 0)\\n    {\\n       strcat(result.letters, \\\"1\\\");\\n       n--;\\n    }\\n\\n    return result;\\n}\\n\", \"untitled.h\"=>\"#ifndef UNTITLED_INCLUDED\\n#define UNTITLED_INCLUDED\\n\\nstruct roman_string\\n{\\n    char letters[32];\\n};\\n\\nstruct roman_string to_roman(int n);\\n\\n#endif\\n\\n\", \"makefile\"=>\"run.tests.output : makefile run.tests\\n\\t./run.tests\\n\\nrun.tests : makefile *.c *.h\\n\\tgcc -Wall -Werror -O -std=c99 *.c -o run.tests\\n\", \"untitled.tests.c\"=>\"#include \\\"untitled.h\\\"\\n#include <assert.h>\\n#include <stdio.h>\\n#include <string.h>\\n#include <stdbool.h>\\n\\nstatic void assert_string_equal(const char * expected, const char * actual)\\n{\\n    if (strcmp(expected, actual) != 0)\\n    {\\n        printf(\\\"expected: %s\\\\n\\\", expected);\\n        printf(\\\"  actual: %s\\\\n\\\", actual);\\n        assert(false);\\n    }\\n}\\n\\nstatic void assert_roman_equal(const char * expected, int n)\\n{\\n    struct roman_string actual = to_roman(n);\\n    assert_string_equal(expected, actual.letters);\\n}\\n\\nstatic void example(void)\\n{\\n    assert_roman_equal(\\\"1\\\", 1);\\n    assert_roman_equal(\\\"2\\\", 2);\\n}\\n\\ntypedef void test(void);\\n\\nstatic test * tests[ ] =\\n{\\n    example,\\n    (test*)0,\\n};\\n\\nint main(void)\\n{\\n    size_t at = 0;\\n    while (tests[at])\\n    {\\n        tests[at++]();\\n        putchar('.');\\n    }\\n    printf(\\\"\\\\n%zd tests passed\\\", at);\\n    return 0;\\n}\\n\\n\", \"cyber-dojo.sh\"=>\"LANG=C\\nmake\\n\", \"instructions\"=>\"Given a positive integer number (eg 42) determine\\nits Roman numeral representation as a String (eg \\\"XLII\\\").\\nThe Roman 'letters' are:\\n\\n1 ->    \\\"I\\\" | 10 ->    \\\"X\\\" | 100 ->    \\\"C\\\" | 1000 ->    \\\"M\\\"\\n2 ->   \\\"II\\\" | 20 ->   \\\"XX\\\" | 200 ->   \\\"CC\\\" | 2000 ->   \\\"MM\\\"\\n3 ->  \\\"III\\\" | 30 ->  \\\"XXX\\\" | 300 ->  \\\"CCC\\\" | 3000 ->  \\\"MMM\\\"\\n4 ->   \\\"IV\\\" | 40 ->   \\\"XL\\\" | 400 ->   \\\"CD\\\" | 4000 -> \\\"MMMM\\\"\\n5 ->    \\\"V\\\" | 50 ->    \\\"L\\\" | 500 ->    \\\"D\\\"\\n6 ->   \\\"VI\\\" | 60 ->   \\\"LX\\\" | 600 ->   \\\"DC\\\" \\n7 ->  \\\"VII\\\" | 70 ->  \\\"LXX\\\" | 700 ->  \\\"DCC\\\" \\n8 -> \\\"VIII\\\" | 80 -> \\\"LXXX\\\" | 800 -> \\\"DCCC\\\" \\n9 ->   \\\"IX\\\" | 90 ->   \\\"XC\\\" | 900 ->   \\\"CM\\\" \\n\\nYou cannot write numerals like IM for 999.\\nWikipedia states \\\"Modern Roman numerals are written by\\nexpressing each digit separately starting with the\\nleftmost digit and skipping any digit with a value of zero.\\\"\\n\\nExamples:\\no) 1990 -> \\\"MCMXC\\\"  (1000 -> \\\"M\\\"  + 900 -> \\\"CM\\\" + 90 -> \\\"XC\\\")\\no) 2008 -> \\\"MMVIII\\\" (2000 -> \\\"MM\\\" +   8 -> \\\"VIII\\\")\\no)   99 -> \\\"XCIX\\\"   (  90 -> \\\"XC\\\" +   9 -> \\\"IX\\\")\\no)   47 -> \\\"XLVII\\\"  (  40 -> \\\"XL\\\" +   7 -> \\\"VII\\\")\\n\\n\", \"output\"=>\"gcc -Wall -Werror -O -std=c99 *.c -o run.tests\\n./run.tests\\nrun.tests: untitled.tests.c:13: assert_string_equal: Assertion `0' failed.\\nexpected: 1\\n  actual: \xEF\xBF\xBD\\b\\u0002@\xEF\xBF\xBD\xEF\xBF\xBD\\u0004\\b(?\\u0003@\xEF\xBF\xBD\xEF\xBF\xBD\\u0004\\b\\u00011\\nmake: *** [run.tests.output] Aborted\\n\"}\n"    

    # p visible_files.inspect
    #visible_files.each do |filename,content|
    #  p filename
    #end
    
    # this was extracted using irb and
    #   >cmd = 'cd elephant; git diff --ignore-space-at-eol --find-copies-harder 10 11 sandbox'
    #   >diff_lines = IO::popen(cmd).read
    
    diff_lines =
    [     
      "diff --git a/sandbox/output b/sandbox/output",
      "index 1633b9f..2b8171e 100644",
      "--- a/sandbox/output",
      "+++ b/sandbox/output",
      "@@ -1,4 +1,6 @@",
      "gcc -Wall -Werror -O -std=c99 *.c -o run.tests",
      "./run.tests",
      "-.",
      "-1 tests passed",
      "\\ No newline at end of file",
      "+run.tests: untitled.tests.c:13: assert_string_equal: Assertion `0' failed.",
      "+expected: 1",
      "+  actual: \xA0\b\x02@\xAD\x82\x04\b(?\x03@\xE8\x81\x04\b\x011",
      "+make: *** [run.tests.output] Aborted",
      "diff --git a/sandbox/untitled.c b/sandbox/untitled.c",
      "index 6b3ec15..7d543eb 100644",
      "--- a/sandbox/untitled.c",
      "+++ b/sandbox/untitled.c",
      "@@ -5,10 +5,11 @@ struct roman_string to_roman(int n)",
      " {",
      "     struct roman_string result;",
      " ",
      "-    if (n == 1)",
      "-        strcpy(result.letters, \"1\");",
      "-    if (n == 2)",
      "-        strcpy(result.letters, \"2\");",
      "+    while (n > 0)",
      "+    {",
      "+       strcat(result.letters, \"1\");",
      "+       n--;",
      "+    }",
      " ",
      "     return result;",
      " }"     
    ].join("\n")
        
    # mimic what is in diff_controller.show
    view = unit_testable_git_diff_view(diff_lines, visible_files)        
    diffs = git_diff_prepare(view)    
    current_filename = 'untitled.c'
    current_filename_id = most_changed_lines_file_id(diffs, current_filename)
        
    p view.inspect
    p diffs.inspect
    p current_filename_id
    
    # OK. Lets look at the actual server log carefully. It says
    #Completed 500 Internal Server Error in 56ms
    #  
    #ArgumentError (invalid byte sequence in UTF-8):
    #  lib/LineSplitter.rb:23:in `split'
    #  lib/LineSplitter.rb:23:in `line_split'
    #  lib/GitDiffParser.rb:12:in `initialize'
    #  lib/GitDiff.rb:16:in `new'
    #  lib/GitDiff.rb:16:in `git_diff_view'
    #  app/controllers/diff_controller.rb:12:in `show'    
    
    # That's pretty clear.
    # And I recall something similar to this before.
    # Yes. In sandbox.test
    #    output.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace)    
    
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "another specific real dojo that once failed a diff" do    
    bad_diff_lines =
    [
      "diff --git a/sandbox/recently_used_list.cpp b/sandbox/was_recently_used_list.test.cpp",
      "similarity index 100%",
      "copy from sandbox/recently_used_list.cpp",
      "copy to sandbox/was_recently_used_list.test.cpp",
    ].join("\n")
    
    diff = GitDiffParser.new(bad_diff_lines).parse_all

    expected_diff = 
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/recently_used_list.cpp b/sandbox/was_recently_used_list.test.cpp",
            "similarity index 100%",
            "copy from sandbox/recently_used_list.cpp",
            "copy to sandbox/was_recently_used_list.test.cpp",
          ],
        :was_filename => 'a/sandbox/recently_used_list.cpp',
        :now_filename => 'b/sandbox/was_recently_used_list.test.cpp',
        :chunks =>
          [
          ] # chunks
    }
    expected = {
      "b/sandbox/was_recently_used_list.test.cpp" => expected_diff
    }
    assert_equal expected, diff
    
  end
  
  test "specific real dojo that fails diff show narrowing" do

    visible_files = { } 
    visible_files['gapper.rb'] =    
          [
            "",
            "def as_time(t)",
            "  [t.year, t.month, t.day, t.hour, t.min, t.sec]",
            "end",
            "",
            "def gapper(lights, from, to, secs_per_gap)",
            "  gaps = [as_time(from)]  ",
            "  while (from + secs_per_gap < to)",
            "    from += secs_per_gap;",
            "    gaps << as_time(from)",
            "  end",
            "  gaps",
            "end",
            "",
            ""
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
    
    diffs = GitDiffParser.new(diff_lines).parse_all
    sandbox_name = 'b/sandbox/gapper.rb' 
    diff = diffs[sandbox_name]
    expected_diff = 
    {
        :prefix_lines =>  
          [
            "diff --git a/sandbox/gapper.rb b/sandbox/gapper.rb",
            "index 6cf082b..08e1893 100644",
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
              :before_lines => [ "  gaps", "end", "" ],
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
    builder = GitDiffBuilder.new()
    view = builder.build(diff, split_up)
    nils = view.select { |one| one[:line] == nil }
    assert_not_equal [ ], nils
    
    # OK. And after all that the problem is the split.
    assert_equal [ ], "\n\n".split("\n")

    # that's not what I want
    # I want "\n\n" --> [ "", "" ]
    # So...
    assert_equal [ "", "" ], "\n\n".split(/(\n)/).select { |line| line != "\n" }
    
    # And to double check...
    
    split_up = source_lines.split(/(\n)/).select { |line| line != "\n"}
    builder = GitDiffBuilder.new()
    view = builder.build(diff, split_up)
    nils = view.select { |one| one[:line] == "\n" }
    assert_equal [ ], nils

  end

end
