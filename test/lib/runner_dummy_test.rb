#!/bin/bash ../test_wrapper.sh

require_relative 'LibTestBase'

class RunnerDummyTests < LibTestBase

  def setup
    super
    @runner = RunnerDummy.new
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'D36271',
  'runnable? is always false' do
    assert !@runner.runnable?(languages['Asm-assert'])
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'B113E1',
  'run tells you how to use HostTestRunner' do
    output = @runner.run(nil,nil,nil)
    assert output.include?('to use DockerVolumeMountRunner')
    assert output.include?('$ export CYBER_DOJO_RUNNER_CLASS_NAME=DockerVolumeMountRunner')
  end

end
