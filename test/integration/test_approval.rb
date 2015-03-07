#!/usr/bin/env ruby

require_relative 'integration_test_base'
require 'tmpdir'

class ApprovalTests < IntegrationTestBase

  include ExternalSetter
  
  def setup
    super
    reset_external(:runner, TestRunnerStub.new)
    @dir = SandboxStub.new(Dir.mktmpdir).dir
  end

  def teardown
    `rm -rf #{@dir.path}`
  end

  class SandboxStub
    def initialize(path)
      @path = path
    end
    def path
      @path
    end
    include ExternalDiskDir
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
