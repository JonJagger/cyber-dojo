require File.dirname(__FILE__) + '/../test_helper'
require 'ExposedLinux/Paas'

class ExercisesTests < ActionController::TestCase

  test "dojo.exercises.each forwards to exercises_each on paas" do
    paas = ExposedLinux::Paas.new
    dojo = paas.create_dojo(root_path,'rb')
    assert_equal ["Fizz Buzz","Roman Numerals"], dojo.exercises.map {|exercise| exercise.name}
  end

  test "dojo.exercises[name]" do
    paas = ExposedLinux::Paas.new
    dojo = paas.create_dojo(root_path,'rb')
    exercise = dojo.exercises["Fizz Buzz"]
    assert_equal ExposedLinux::Exercise, exercise.class
    assert_equal "Fizz Buzz", exercise.name
  end

end
