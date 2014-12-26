#!/usr/bin/env ruby

require_relative 'model_test_base'

class ExercisesTests < ModelTestBase

  test 'dojo.exercises.each() gives all exercises which exist' do
    names = ['Unsplice','Verbal','Salmo']
    stub_exists(names)
    exercises_names = @dojo.exercises.map {|exercise| exercise.name}
    assert_equal names.sort, exercises_names.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'dojo.exercises[name] returns exercise with given name' do
    name = 'Print_Diamond'
    exercise = @dojo.exercises[name]
    assert_equal Exercise, exercise.class
    assert_equal name, exercise.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'dojo.exercise.instructions' do
    name = 'Yahtzee'
    exercise = @dojo.exercises[name]
    content = 'your task...'
    exercise.dir.write('instructions', content)
    assert_equal content, exercise.instructions
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def stub_exists(exercises_names)
    exercises_names.each do |name|
      exercise = @dojo.exercises[name]
      exercise.dir.write('instructions', '')
    end
  end

end
