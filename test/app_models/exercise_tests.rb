require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/stub_disk'

class ExerciseTests < ActionController::TestCase
    
  def setup
    Thread.current[:file] = @disk = StubDisk.new
    dir = '/stubbed'
    @exercise = Dojo.new(dir).exercise('Yahtzee')
  end
  
  def teardown
    Thread.current[:file] = nil
  end
    
  #- - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "exists? is false when exercise folder does not exist" do
    dir = '/perch'
    assert !Dojo.new(dir).exercise('xxxx').exists?    
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "exists? is true when exercise folder exists" do
    @disk[@exercise.dir,'instructions'] = "your task..."
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
    assert !@exercise.dir.end_with?(@disk.separator),
          "!#{@exercise.dir}.end_with?(#{@disk.separator})"
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "dir does not have doubled separator" do
    doubled_separator = @disk.separator * 2
    assert_equal 0, @exercise.dir.scan(doubled_separator).length
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "instructions are loaded" do
    @disk[@exercise.dir,'instructions'] = 'Fishing on the Verdal'
    instructions = @exercise.instructions
    assert_not_nil instructions
    assert instructions.start_with? "Fishing on the Verdal"
  end

end
