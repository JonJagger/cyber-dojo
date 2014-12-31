#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'
require 'tmpdir'

class ApprovalTests < CyberDojoTestBase

  def setup
    thread = Thread.current
    thread[:disk] = Disk.new
    thread[:git] = SpyGit.new
    thread[:runner] = StubTestRunner.new
    root_path = 'unused'
    @dojo = Dojo.new(root_path)
    @temp_dir = Dir.mktmpdir
    @sandbox = StubSandbox.new(@temp_dir)
  end

  def teardown
    `rm -rf #{@temp_dir}`
  end

  class StubSandbox
    def initialize(dir)
      @dir = dir
    end
    def dir
      Thread.current[:disk][@dir]
    end
  end

  test 'after test Approval newly created txt files are added ' +
       'to visible_files and existing deleted txt files are ' +
       'removed from visible_files' do
    name = 'Ruby-Approval'
    @language = @dojo.languages[name]
    @sandbox.dir.write('created.txt', 'content')
    @sandbox.dir.write('wibble.hpp', 'non txt file')
    visible_files = {
      'deleted.txt' => 'once upon a time',
      'wibble.cpp'  => '#include <wibble.hpp>'
    }
    @language.after_test(@sandbox, visible_files)
    expected = {
      'created.txt' => 'content',
      'wibble.cpp'  => '#include <wibble.hpp>'
    }
    assert_equal expected, visible_files
  end

end
