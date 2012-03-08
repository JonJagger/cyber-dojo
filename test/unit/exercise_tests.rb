require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

class ExerciseTests < ActionController::TestCase

  test "name" do
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
