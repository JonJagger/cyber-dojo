#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/model_test_case'

class ExercisesTests < ModelTestCase

  test "dojo.exercises.each() forwards to paas.all_exercises()" do
    stub_exists(['Unsplice','Verbal','Salmo'])
    exercises_names = @dojo.exercises.map {|exercise| exercise.name}
    assert exercises_names.include?('Unsplice'), 'Unsplice: ' + exercises_names.inspect
    assert exercises_names.include?('Verbal'), 'Verbal: ' + exercises_names.inspect
    assert exercises_names.include?('Salmo'), 'Salmo: ' + exercises_names.inspect
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "dojo.exercises[name] returns exercise with given name" do
    name = 'Print_Diamond'
    exercise = @dojo.exercises[name]
    assert_equal Exercise, exercise.class
    assert_equal name, exercise.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "dojo.exercise.instructions" do
    name = 'Yahtzee'
    exercise = @dojo.exercises[name]
    content = 'your task...'
    exercise.dir.spy_read('instructions', content)
    assert_equal content, exercise.instructions
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def stub_exists(exercises_names)
    exercises_names.each do |name|
      exercise = @dojo.exercises[name]
      exercise.dir.spy_exists?('instructions')
    end
  end

end
