#!/bin/bash ../test_wrapper.sh

require_relative 'lib_test_base'

class RunnerDummyTests < LibTestBase

  def setup
    super
    @runner = RunnerDummy.new
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'runnable? is always false' do
    assert !@runner.runnable?(languages['Asm-assert'])
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'run tells you how to use HostTestRunner' do
    output = @runner.run(nil,nil,nil)
    assert output.include?('to use DockerVolumeMountRunner')
    assert output.include?('$ export CYBER_DOJO_RUNNER_CLASS_NAME=DockerVolumeMountRunner')
  end

end
