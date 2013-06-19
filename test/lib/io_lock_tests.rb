require File.dirname(__FILE__) + '/../test_helper'
require 'Files'
require 'Locking'

class IoLockTests < ActionController::TestCase
  
  test "if_path_does_not_exist_exception_is_thrown_block_is_not_executed_and_result_is_nil" do
    block_run = false
    exception_throw = false
    begin
      result = Locking::io_lock('does_not_exist.txt') do |fd|
        block_run = true
      end
    rescue
      exception_thrown = true
    end

    assert exception_thrown
    assert !block_run
    assert_nil result
  end

  test "if_lock_is_obtained_block_is_executed_and_result_is_result_of_block" do
    block_run = false
    filename = 'exists.txt'
    Files::file_write('.', filename, 'x=[1,2,3]')
    fd = File.open(filename, 'r')
    begin
      result = Locking::io_lock(filename) {|fd| block_run = true; 'Hello' }
      assert block_run, 'block_run'
      assert_equal 'Hello', result
    ensure
      File.delete(filename)
    end
  end
  
  test "outer_iolock_is_blocking_so_inner_iolock_blocks" do
    filename = 'exists.txt'
    Files::file_write('.', filename, 'x=[1,2,3]')
    outer_run = false
    inner_run = false
    Locking::io_lock(filename) do
      outer_run = true
      
      inner_thread = Thread.new {
        Locking::io_lock(filename) do
          inner_run = true
        end
      }
      max_seconds = 2
      result = inner_thread.join(max_seconds);
      timed_out = (result == nil)
      if inner_thread != nil
        Thread.kill(inner_thread)
      end
    end
    assert outer_run
    assert !inner_run
    `rm #{filename}`
  end
  
  test "lock_can_be_acquired_on_an_existing_dir" do
    dir = 'new_dir'
    `mkdir #{dir}`
    begin
      run = false
      result = Locking::io_lock(dir) {|_| run = true }
      assert run
      assert result
    ensure
      `rmdir #{dir}`      
    end
  end
  
  test "holding_lock_on_parent_dir_does_not_prevent_acquisition_of_lock_on_child_dir" do
    parent = 'parent'
    child = parent + File::SEPARATOR + 'child'
    `mkdir #{parent}`
    `mkdir #{child}`
    begin
      parent_run = false
      child_run = false
      Locking::io_lock(parent) do
        parent_run = true
        Locking::io_lock(child) do
          child_run = true
        end
      end
      assert parent_run
      assert child_run
    ensure
      `rmdir #{child}`
      `rmdir #{parent}`
    end
  end
  
end


