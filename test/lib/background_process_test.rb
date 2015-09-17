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

end
