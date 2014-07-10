#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'

class DummyTestRunnerTests < CyberDojoTestBase

  test 'runnable? is false' do
    assert !DummyTestRunner.new.runnable?('kermit-the-frog')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'run tells you how to use HostTestRunner' do
    output = DummyTestRunner.new.run(nil,nil,nil)
    assert output.include?('$ export CYBERDOJO_USE_HOST=true')
  end

end
