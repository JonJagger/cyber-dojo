require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/spy_disk'

class ExerciseTests < ActionController::TestCase

  def setup
    Thread.current[:disk] = @disk = SpyDisk.new
    #@exercise = Dojo.new('spied/').exercise('Yahtzee')
  end

  def teardown
    @disk.teardown
    Thread.current[:disk] = nil
  end

  def rb_and_json(&block)
    block.call('rb')
    teardown
    setup
    block.call('json')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "when no disk on thread the ctor raises" do
    Thread.current[:disk] = nil
    error = assert_raises(RuntimeError) { Exercise.new(nil,nil) }
    assert_equal "no disk", error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "exists? is false when dir does not exist, true when dir exists" do
    rb_and_json(&Proc.new{|format|
      exercise = Dojo.new('spied/',format).exercise('Yahtzee')
      assert !exercise.exists?
      exercise.dir.make
      assert exercise.exists?
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "name is as set in ctor" do
    rb_and_json(&Proc.new{|format|
      exercise = Dojo.new('spied/',format).exercise('Yahtzee')
      assert_equal 'Yahtzee', exercise.name
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path is based on name" do
    rb_and_json(&Proc.new{|format|
      exercise = Dojo.new('spied/',format).exercise('Yahtzee')
      assert exercise.path.match(exercise.name), exercise.path
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path ends in a slash" do
    rb_and_json(&Proc.new{|format|
      exercise = Dojo.new('spied/',format).exercise('Yahtzee')
      assert exercise.path.end_with?(@disk.dir_separator)
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path does not have doubled separator" do
    rb_and_json(&Proc.new{|format|
      exercise = Dojo.new('spied/',format).exercise('Yahtzee')
      doubled_separator = @disk.dir_separator * 2
      assert_equal 0, exercise.path.scan(doubled_separator).length
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "instructions are loaded" do
    rb_and_json(&Proc.new{|format|
      exercise = Dojo.new('spied/',format).exercise('Yahtzee')
      filename = 'instructions'
      content = 'fish for Salmon on the Verdal'
      exercise.dir.spy_read(filename, content)
      assert_equal content, exercise.instructions
      assert exercise.dir.log.include?(['read',filename,content])
    })
  end

end
