#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'

class HostFileLockerTests < LibTestBase

  def path
    tmp_root
  end

  def any_filename
    path + 'f.lock'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '7B7E1A',
    'lock(filename) when filename specifies file in a new folder:' +
      ' throws exception,' +
      ' does not execute block,' +
      ' result is nil' do
    block_run = false
    exception_thrown = false
    begin
      result = HostFileLocker.lock(path + 'does_not_exist/f.lock') { block_run = true }
    rescue StandardError => e
      assert_equal 'Errno::ENOENT', e.class.name
      exception_thrown = true
    end
    assert exception_thrown
    refute block_run
    assert_nil result
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'BE0ED2',
    'when lock is obtained the block is executed' +
       ' and result is result of block' do
    block_run = false
    result = HostFileLocker.lock(any_filename) { block_run = true; 'Hello' }
    assert block_run, 'block_run'
    assert_equal 'Hello', result
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '9E019E',
  'lock is not recursive' do
    outer_run = false
    inner_run = false
    HostFileLocker.lock(any_filename) do
      outer_run = true
      inner_thread = Thread.new { HostFileLocker.lock(any_filename) { inner_run = true } }
      max_wait = 1.0 / 50.0
      inner_thread.join(max_wait)
      Thread.kill(inner_thread)
    end
    assert outer_run
    refute inner_run
  end

end
