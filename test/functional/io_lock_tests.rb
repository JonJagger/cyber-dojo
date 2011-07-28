require File.dirname(__FILE__) + '/../test_helper'
require 'Files'
require 'Locking'

# > cd cyberdojo/test
# > ruby functional/io_lock_tests.rb

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

  def test_if_lock_not_obtained_block_is_not_executed_and_result_is_nil
    block_run = false
    filename = 'exists.txt'
    file_write(filename, 'x=[1,2,3]')
    fd = File.open(filename, 'r')
    begin
      locked = fd.flock(File::LOCK_EX)
      assert locked, 'locked'
      result = io_lock(filename) {|fd| block_run = true; }
      assert !block_run, '!block_run'
      assert_equal nil, result
    ensure
      fd.flock(File::LOCK_UN)
      fd.close
      File.delete(filename)
    end
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
  
end


