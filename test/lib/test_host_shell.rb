#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'

class HostShellTests < LibTestBase

  test 'C89DBB',
  'the daemon_exec command executes' do
    shell.daemon_exec("echo Hello > #{tmp_root}hello.txt")
    sleep 1
    written = `cat #{tmp_root}hello.txt`
    assert written.start_with?('Hello'), written
  end

  # - - - - - - - - - - - - - - - - -

  test 'E180B8',
  'daemon_exec runs as a detached process' +
  ' so it returns immediately even if command is long-lived' do
    how_long = timed { shell.daemon_exec('sleep 5') }
    assert how_long <= 1
    # this will *not* give coverage of the commands inside the daemon_exec's fork!
  end

  # - - - - - - - - - - - - - - - - -

  test '886962',
  "the parent process's lifetime is *not* tied to the child process's lifetime" do
    duration = timed do
      child_pid = shell.daemon_exec('sleep 5')
      Process.waitpid(child_pid)
    end
    assert_equal 0, duration
  end

  # test that daemon_exec does not accumulate zombie processes?

  # - - - - - - - - - - - - - - - - -

  private

  include TimeNow

  def timed
    before = Time.mktime(*time_now)
    yield
    after = Time.mktime(*time_now)
    after - before
  end

end
