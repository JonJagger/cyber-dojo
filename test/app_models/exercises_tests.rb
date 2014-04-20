require File.dirname(__FILE__) + '/model_test_case'

class ExercisesTests < ModelTestCase

  test "dojo.exercises.each() forwards to paas.exercises_each()" do
    @paas.dir(@dojo.exercises['Unsplice'])
    @paas.dir(@dojo.exercises['Verbal'])
    @paas.dir(@dojo.exercises['Yatzy'])
    exercises_names = @dojo.exercises.map {|exercise| exercise.name}
    assert exercises_names.include?('Unsplice'), 'Unsplice: ' + exercises_names.inspect
    assert exercises_names.include?('Verbal'), 'Verbal: ' + exercises_names.inspect
    assert exercises_names.include?('Yatzy'), 'Yatzy: ' + exercises_names.inspect
  end

  test "dojo.exercises[name] returns exercise with given name" do
    name = 'Print_Diamond'
    exercise = @dojo.exercises[name]
    assert_equal Exercise, exercise.class
    assert_equal name, exercise.name
  end

  test "dojo.exercise.instructions" do
    name = 'Print_Diamond'
    exercise = @dojo.exercises[name]
    @paas.dir(exercise).spy_read('instructions', 'your task...')
    exercise = @dojo.exercises[name]
    assert_equal 'your task...', exercise.instructions
  end

end
