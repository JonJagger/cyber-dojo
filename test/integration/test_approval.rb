#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'
require 'tmpdir'

class ApprovalTests < CyberDojoTestBase

  def setup
    thread = Thread.current
    thread[:disk] = Disk.new
    thread[:runner] = StubTestRunner.new
    root_path = 'unused'
    @dojo = Dojo.new(root_path)
    @dir = StubSandbox.new(Dir.mktmpdir).dir
  end

  def teardown
    `rm -rf #{@dir.path}`
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
    @dir.write('created.txt', 'content')
    @dir.write('wibble.hpp', 'non txt file')
    visible_files = {
      'deleted.txt' => 'once upon a time',
      'wibble.cpp'  => '#include <wibble.hpp>'
    }
    @language.after_test(@dir, visible_files)
    expected = {
      'created.txt' => 'content',
      'wibble.cpp'  => '#include <wibble.hpp>'
    }
    assert_equal expected, visible_files
  end

end
