require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

# > ruby test/functional/exercise_file_set_tests.rb

class ExerciseFileSetTests < ActionController::TestCase
    
  def filesets_root
    RAILS_ROOT +  '/filesets'
  end
    
  def exercise
    'Yahtzee'
  end
  
  def test_instructions
    fileset = ExerciseFileSet.new(filesets_root, exercise)
    instructions = fileset.instructions
    assert_not_nil instructions
    assert instructions.start_with? "The game of yahtzee"
  end
  
  def test_exercise
    fileset = ExerciseFileSet.new(filesets_root, exercise)
    assert exercise, fileset.exercise
  end
  
end
