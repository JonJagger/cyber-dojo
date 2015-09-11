#!/bin/bash ../test_wrapper.sh

require 'minitest/autorun'
require_relative '../ideas/TestWithId'
require_relative 'lib_test_base'

class CurlOneSelfTests < LibTestBase #MiniTest::Test

  def self.tests
    @@tests ||= TestWithId.new(self)
  end

  tests['F01E97'].is 'A process started in the background does not block' do
    background_process = BackgroundProcess.new

    start_time = Time.now
    background_process.start("sleep 10")
    end_time = Time.now

    run_time = (end_time - start_time) * 1000 # total run time in milliseconds

    assert run_time < 1000, "Starting the background process took longer than 1 second to complete"
  end

end
