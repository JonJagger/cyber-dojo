require File.dirname(__FILE__) + '/../test_helper'
require 'OsDisk'
require 'Git'
require 'RawRunner'

class ZombieShellTests < ActionController::TestCase

  def setup
    disk   = OsDisk.new
    git    = Git.new
    runner = RawRunner.new
    paas = LinuxPaas.new(disk, git, runner)
    format = 'json'
    @dojo = paas.create_dojo(root_path, format)
  end

  def defunct_count
    `ps`.scan(/<defunct>/).length
  end

  test "check running tests does not accumulate zombie defunct shell processes" do
    kata = make_kata(@dojo, 'Ruby-installed-and-working')

    avatars = [ ]
    visible_files_set = { }
    avatar_count = 4
    avatar_count.times do |n|
      avatar = kata.start_avatar
      visible_files_set[avatar.name] = avatar.visible_files
      avatars << avatar
    end

    run_tests_count = 4
    run_tests_count.times do |n|
      avatars.each do |avatar|
        visible_files = visible_files_set[avatar.name]
        defunct_before = defunct_count
        delta = {
          :changed => visible_files.keys,
          :unchanged => [ ],
          :deleted => [ ],
          :new => [ ]
        }
        output = run_test(delta, avatar, visible_files, timeout=5)
        defunct_after = defunct_count

        assert_equal defunct_before, defunct_after, 'run_test(delta, avatar, visible_files)'

        info = avatar.name + ', red'
        assert_equal 'red', avatar.traffic_lights.last['colour'], info + ', red,' + output
        print 's'
      end
    end
  end

end
