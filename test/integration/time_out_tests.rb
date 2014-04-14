require File.dirname(__FILE__) + '/../test_helper'
require 'OsDisk'
require 'Git'
require 'RawRunner'

class TimeOutTests < ActionController::TestCase

  def setup
    disk   = OsDisk.new
    git    = Git.new
    runner = RawRunner.new
    paas = LinuxPaas.new(disk, git, runner)
    format = 'json'
    @dojo = paas.create_dojo(root_path, format)
  end

  test "that code with infinite loop times out to amber and doesnt leak processes" do
    kata = make_kata(@dojo, 'Ruby-installed-and-working')
    avatar = kata.start_avatar
    visible_files = avatar.visible_files
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
    assert_match(/Terminated by the cyber-dojo server after \d+ seconds?/, output)
    assert_equal 'amber', avatar.traffic_lights.last['colour']
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
