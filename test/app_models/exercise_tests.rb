require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/spy_disk'

class ExerciseTests < ActionController::TestCase

  def setup
    Thread.current[:disk] = @disk = SpyDisk.new
    @exercise = Dojo.new('spied').exercise('Yahtzee')
  end

  def teardown
    Thread.current[:disk] = nil
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "when no disk on thread the ctor raises" do
    Thread.current[:disk] = nil
    error = assert_raises(RuntimeError) { Exercise.new(nil,nil) }
    assert_equal "no disk", error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "exists? is false when dir does not exist, true when dir exists" do
    assert !@exercise.exists?
    @exercise.dir.make
    assert @exercise.exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "name is as set in ctor" do
    assert_equal 'Yahtzee', @exercise.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path is based on name" do
    assert @exercise.path.match(@exercise.name), @exercise.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path does not end in a slash" do
    assert !@exercise.path.end_with?(@disk.dir_separator)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path does not have doubled separator" do
    doubled_separator = @disk.dir_separator * 2
    assert_equal 0, @exercise.path.scan(doubled_separator).length
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "instructions are loaded" do
    @exercise.dir.spy_read('instructions', 'Fishing on the Verdal')
    instructions = @exercise.instructions
    assert_not_nil instructions
    assert instructions.start_with? "Fishing on the Verdal"
  end

end
