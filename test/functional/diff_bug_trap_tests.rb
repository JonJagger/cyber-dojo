require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/diff_bug_trap_tests.rb

class DiffBugTrapTests < ActionController::TestCase

  def test_specific_real_dojo_that_fails_diff_show
    params = { 
      :dojo_name => 'ruby-gapper', 
      :dojo_root => Dir.getwd + '/../dojos',
    }
    dojo = Dojo.new(params)
    avatar = Avatar.new(dojo, 'elephant')
    tag = 26
    diffed_files = git_diff_view(avatar, tag)    
    diffed_files['gapper.rb'].each do |diff|
      assert_not_equal nil, diff[:line], diff.inspect  # YES. GOT IT
    end  
  end

end
