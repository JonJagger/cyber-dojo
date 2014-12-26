#!/usr/bin/env ruby

require_relative 'model_test_base'

class ExerciseTests < ModelTestBase

  test 'path(exercise)' do
    exercise = @dojo.exercises['test_Yahtzee']
    assert exercise.path.match(exercise.name)
    assert path_ends_in_slash?(exercise)
    assert !path_has_adjacent_separators?(exercise)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'exists? is true only if dir and instructions exist' do
    exercise = @dojo.exercises['test_Yahtzee']
    assert !exercise.exists?
    exercise.dir.make
    assert !exercise.exists?
    exercise.dir.write('instructions', '')
    assert exercise.exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'name is as set in ctor' do
    exercise = @dojo.exercises['test_Yahtzee']
    assert_equal 'test_Yahtzee', exercise.name
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'instructions are loaded from file of same name' do
    exercise = @dojo.exercises['test_Yahtzee']
    content = 'The game of Yahtzee...'
    exercise.dir.write('instructions', content)
    assert_equal content, exercise.instructions
  end

end
