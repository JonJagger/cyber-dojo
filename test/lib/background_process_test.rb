#!/bin/bash ../test_wrapper.sh

require_relative 'LibTestBase'

class CurlOneSelfTests < LibTestBase

  test 'D54BA5',
  'A process started in the background does not block' do
    background_process = BackgroundProcess.new

    start_time = Time.now
    background_process.start("sleep 10")
    end_time = Time.now

    run_time = (end_time - start_time) * 1000 # total run time in milliseconds

    assert run_time < 1000, "Starting the background process took longer than 1 second to complete"
  end

  test '4e78b26f',
  'Starting a background process that does not exist does not crash the host process' do
    background_process = BackgroundProcess.new

    background_process.start("this-does-not-exist")
  end

end
