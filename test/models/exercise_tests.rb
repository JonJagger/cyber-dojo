require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

class ExerciseTests < ActionController::TestCase
  
  test "dir is based on name" do
    exercise = make_exercise('Yahtzee') 
    assert exercise.dir.match(exercise.name), exercise.dir
  end
  
  test "dir does not end in a slash" do
    exercise = make_exercise('Yahtzee') 
    assert !exercise.dir.end_with?(File::SEPARATOR),
          "!#{exercise.dir}.end_with?(#{File::SEPARATOR})"      
  end
  
  test "dir does not have doubled separator" do
    exercise = make_exercise('Yahtzee') 
    doubled_separator = File::SEPARATOR + File::SEPARATOR
    assert_equal 0, exercise.dir.scan(doubled_separator).length    
  end
  
  test "name is as set in ctor" do
    exercise = make_exercise('Yahtzee')    
    assert_equal 'Yahtzee', exercise.name
  end

  test "instructions are loaded" do
    exercise = make_exercise('Yahtzee')
    instructions = exercise.instructions
    assert_not_nil instructions
    assert exercise.instructions.start_with? "The game of Yahtzee..."
  end
  
  def make_exercise(name)
    Exercise.new(root_dir, name)
  end
    
end
