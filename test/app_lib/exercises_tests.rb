require File.dirname(__FILE__) + '/../test_helper'
require 'ExposedLinux/Paas'

class ExercisesTests < ActionController::TestCase

  def setup
    paas = ExposedLinux::Paas.new
    @dojo = paas.create_dojo(root_path + '../../','rb')
  end

  test "dojo.exercises.each forwards to exercises_each on paas" do
    exercises = @dojo.exercises.map {|exercise| exercise.name}
    assert exercises.include? "Unsplice"
    assert exercises.include? "Verbal"
    assert exercises.include? "Yatzy"
  end

  test "dojo.exercises[name]" do
    exercise = @dojo.exercises["Print_Diamond"]
    assert_equal ExposedLinux::Exercise, exercise.class
    assert_equal "Print_Diamond", exercise.name
  end

end
