#!/bin/bash ../test_wrapper.sh

require_relative 'LibTestBase'

class CurlOneSelfTests < LibTestBase

  def setup
    super
    @background_process = BackgroundProcess.new  
  end

  test 'D54BA5',
  'A process started in the background does not block' do
    start_time = Time.now
    @background_process.start('sleep 10')
    end_time = Time.now
    run_time = (end_time - start_time) * 1000 # total run time in milliseconds
    assert run_time < 1000, 'Starting the background process took longer than 1 second to complete'
  end

  test '4E78B2',
  'Starting a background process that does not exist does not leak an exception' do
    @background_process.start('this-does-not-exist')
  end

end
