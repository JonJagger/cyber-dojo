require File.dirname(__FILE__) + '/model_test_case'

class ExercisesTests < ModelTestCase

  def stub_exists(exercises_names)
    exercises_names.each do |name|
      exercise = @dojo.exercises[name]
      @paas.dir(exercise).spy_read('instructions','your task...')
      exercise.instructions # stop spy saying 'not read'
    end
  end

  test "dojo.exercises.each() forwards to paas.all_exercises()" do
    stub_exists(['Unsplice','Verbal','Salmo'])
    exercises_names = @dojo.exercises.map {|exercise| exercise.name}
    assert exercises_names.include?('Unsplice'), 'Unsplice: ' + exercises_names.inspect
    assert exercises_names.include?('Verbal'), 'Verbal: ' + exercises_names.inspect
    assert exercises_names.include?('Salmo'), 'Salmo: ' + exercises_names.inspect
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
    assert_equal 'your task...', exercise.instructions
  end

end
