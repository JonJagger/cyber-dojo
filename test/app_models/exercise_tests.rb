require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/spy_disk'

class ExerciseTests < ActionController::TestCase

  def setup
    Thread.current[:disk] = @disk = SpyDisk.new
    @exercise = Dojo.new('stubbed').exercise('Yahtzee')
  end

  def teardown
    Thread.current[:disk] = nil
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "exists? is false when dir does not exist, true when dir exists" do
    assert !@exercise.exists?
    @disk[@exercise.dir].make
    assert @exercise.exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "name is as set in ctor" do
    assert_equal 'Yahtzee', @exercise.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "dir is based on name" do
    assert @exercise.dir.match(@exercise.name), @exercise.dir
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "dir does not end in a slash" do
    assert !@exercise.dir.end_with?(@disk.dir_separator)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "dir does not have doubled separator" do
    doubled_separator = @disk.dir_separator * 2
    assert_equal 0, @exercise.dir.scan(doubled_separator).length
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "instructions are loaded" do
    @disk[@exercise.dir].spy_read('instructions', 'Fishing on the Verdal')
    instructions = @exercise.instructions
    assert_not_nil instructions
    assert instructions.start_with? "Fishing on the Verdal"
  end

end
