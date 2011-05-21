require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/git_diff_tests.rb

class GitDiff
  def initialize(diff_string)
  end

  def original_filename
    'gapper.rb'
  end



  def new_filename
    'gapper.rb'
  end
  
end


class GitDiffTests < ActionController::TestCase

# git diff 96 97 sandbox/gapper.rb
  def git_diff_96_97
    string = <<HERE
diff --git a/sandbox/gapper.rb b/sandbox/gapper.rb
index 26bc41b..8a5b0b7 100644
--- a/sandbox/gapper.rb
+++ b/sandbox/gapper.rb
@@ -4,7 +4,8 @@ def time_gaps(from, to, seconds_per_gap)
   (0..n+1).collect {|i| from + i * seconds_per_gap }
 end
 
-def full_gapper(all_incs, gaps)
+def full_gapper(all_incs, created, seconds_per_gap)
+  gaps = time_gaps(created, latest(all_incs), seconds_per_gap)
   full = {}
   all_incs.each do |avatar_name, incs|
     full[avatar_name.to_sym] = gapper(incs, gaps)
HERE
  string
end

  def test_replace_one_line_with_two_lines
    gd = GitDiff.new(git_diff_96_97)
    assert_equal 'gapper.rb', gd.original_filename
    assert_equal 'gapper.rb', gd.new_filename
    
  end

end
