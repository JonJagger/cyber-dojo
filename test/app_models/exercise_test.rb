#!/bin/bash ../test_wrapper.sh

require_relative 'AppModelTestBase'

class ExerciseTests < AppModelTestBase

  test '2DDD85',
  "exercise path has correct basic format" do
    exercise = exercises['Fizz_Buzz']
    assert exercise.path.match(exercise.name)
    assert correct_path_format?(exercise)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test '73C3A7',
  'exists? is false if exercise does not exist' do
    exercise = exercises['wibble_XXX']
    refute exercise.exists?
  end
  
  #- - - - - - - - - - - - - - - - - - - - - -

  test '10EEF3',
  'name is as set in ctor' do
    exercise = exercises[name = 'Fizz_Buzz']
    assert_equal name, exercise.name
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test '71265F',
  'instructions are loaded from file of same name' do
    exercise = exercises['Fizz_Buzz']
    assert exercise.instructions.start_with? 'Write a program that prints'
  end

end
