#!/usr/bin/env ruby

require_relative '../test_helper'
require_relative 'externals'

class TimeOutTests < ActionController::TestCase

  include Externals

  def setup
    @dojo = Dojo.new(root_path,externals)
  end

  test "that code with infinite loop times out to amber and doesnt leak processes" do
    kata = make_kata(@dojo, 'Ruby-installed-and-working')
    avatar = kata.start_avatar
    visible_files = avatar.tags[0].visible_files
    filename = 'untitled.rb'
    code = visible_files[filename]
    visible_files[filename] = code.sub('42', 'while true;end')
    ps_count_before = ps_count
    print 't'
    STDOUT.flush
    delta = {
      :changed => visible_files.keys,
      :unchanged => [ ],
      :deleted => [ ],
      :new => [ ]
    }
    output = run_test(delta, avatar, visible_files, timeout = 5)
    assert_equal :amber, avatar.lights.latest.colour
    ps_count_after = ps_count
    # This often fails with
    # <1> expected but was
    # <2>
    assert_equal ps_count_before, ps_count_after, 'proper cleanup of shell processes'
  end

  def ps_count
    `ps aux | grep -E "(cyber-dojo)"`.lines.count
  end

end
