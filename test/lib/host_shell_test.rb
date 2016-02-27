#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'

class HostShellTest < LibTestBase

  test 'C89DBB',
  'when the exec command succeeds output is captured and exit-status is zero' do
    output, exit_status = shell.exec('echo Hello')
    assert_equal "Hello\n", output
    assert_equal 0, exit_status
  end

  test '3C3AF6',
  'when the exec command fails output is captured and exit-status is non zero' do
    output, exit_status = shell.exec('zzzz 2> /dev/null')
    refute_equal 0, exit_status
  end

  # - - - - - - - - - - - - - - - - -

  test 'E180B8',
  'when the cd_exec command succeeds output is captured and exit-status is zero' do
    output, exit_status = shell.cd_exec('.', 'echo Hello')
    assert_equal "Hello\n", output
    assert_equal 0, exit_status
  end

  test '373995',
  'when the cd_exec command fails output is captured and exit-status is non zero' do
    output, exit_status = shell.cd_exec('.', 'zzzz 2> /dev/null')
    refute_equal 0, exit_status
  end

  test '565ACD',
  'when the cd fails the command is not executed and exit-status is non-zero' do
    output, exit_status = shell.cd_exec('zzzz', 'echo Hello')
    assert_equal '', output
    refute_equal 0, exit_status
  end

end
