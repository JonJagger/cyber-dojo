#!/bin/bash ../test_wrapper.sh

require_relative 'model_test_base'

class ExerciseTests < ModelTestBase

  test 'path(exercise)' do
    exercise = exercises['Fizz_Buzz']
    assert exercise.path.match(exercise.name)
    assert path_ends_in_slash?(exercise)
    assert path_has_no_adjacent_separators?(exercise)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'exists? is false if exercise does not exist' do
    exercise = exercises['wibble_XXX']
    assert !exercise.exists?
  end
  
  #- - - - - - - - - - - - - - - - - - - - - -

  test 'name is as set in ctor' do
    name = 'Fizz_Buzz'
    exercise = exercises[name]
    assert_equal name, exercise.name
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'instructions are loaded from file of same name' do
    exercise = exercises['Fizz_Buzz']
    assert exercise.instructions.start_with? 'Write a program that prints'
  end

end
