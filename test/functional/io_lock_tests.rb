require File.dirname(__FILE__) + '/../test_helper'
require 'Files'
require 'Locking'

# > ruby test/functional/io_lock_tests.rb

class IoLockTests < Test::Unit::TestCase
  
  include Files
  include Locking
  
  def test_if_path_does_not_exist_exception_is_thrown_block_is_not_executed_and_result_is_nil
    block_run = false
    exception_throw = false
    begin
      result = io_lock('does_not_exist.txt') do |fd|
        block_run = true
      end
    rescue
      exception_thrown = true
    end

    assert exception_thrown
    assert !block_run
    assert_equal nil, result
  end

  def test_if_lock_is_obtained_block_is_executed_and_result_is_result_of_block
    block_run = false
    filename = 'exists.txt'
    file_write(filename, 'x=[1,2,3]')
    fd = File.open(filename, 'r')
    begin
      result = io_lock(filename) {|fd| block_run = true; 'Hello' }
      assert block_run, 'block_run'
      assert_equal 'Hello', result
      assert fd.closed?
    ensure
      File.delete(filename)
    end
  end
  
  def test_when_file_is_locked_then_io_lock_waits_till_its_unlocked
    filename = 'locked_file.txt'
    `echo xx > #{filename}`
    f1 = File.open(filename)
    result = f1.flock(File::LOCK_EX)
    assert_equal 0, result

    second_lock_blocked_when_first_lock_not_yet_closed = true    
    blocked = Thread.new {
      File.open(filename).flock(File::LOCK_EX)
      second_lock_blocked_when_first_lock_not_yet_closed = false
    }
    result = blocked.join(2)
    assert second_lock_blocked_when_first_lock_not_yet_closed
    
    f1.close()
    
    second_lock_acquired_when_first_lock_closed = false
    acquired = Thread.new {
      f2 = File.open(filename)
      f2.flock(File::LOCK_EX)
      second_lock_acquired_when_first_lock_closed = true
      f2.close()      
    }
    
    result = acquired.join()
    assert second_lock_acquired_when_first_lock_closed
    
    `rm #{filename}`
  end
    
end


