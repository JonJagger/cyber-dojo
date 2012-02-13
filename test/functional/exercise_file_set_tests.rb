require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

# > ruby test/functional/exercise_file_set_tests.rb

class ExerciseFileSetTests < ActionController::TestCase
    
  def test_instructions
    params = {
      :filesets_root => RAILS_ROOT +  '/filesets',
      :exercise => 'Yahtzee',
    }
    fileset = ExerciseFileSet.new(params[:filesets_root] + '/exercise/' + params[:exercise])
    instructions = fileset.instructions
    assert_not_nil instructions
    assert instructions.start_with? "The game of yahtzee"
  end
  
end
