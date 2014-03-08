require File.dirname(__FILE__) + '/../test_helper'
require 'ExposedLinux/Paas'
require File.dirname(__FILE__) + '/../app_models/spy_disk'
require File.dirname(__FILE__) + '/../app_models/stub_git'

class ExercisesTests < ActionController::TestCase

  def setup
    @disk = SpyDisk.new
    @git = StubGit.new
    @paas = ExposedLinux::Paas.new(@disk,@git)
    @dojo = @paas.create_dojo(root_path + '../../','rb')
  end

  def teardown
    @disk.teardown
  end

  test "dojo.exercises.each forwards to exercises_each on paas" do
    exercises = @dojo.exercises.map {|exercise| exercise.name}
    assert exercises.include? 'Unsplice'
    assert exercises.include? 'Verbal'
    assert exercises.include? 'Yatzy'
  end

  test "dojo.exercises[name]" do
    name = 'Print_Diamond'
    exercise = @dojo.exercises[name]
    assert_equal ExposedLinux::Exercise, exercise.class
    assert_equal name, exercise.name
  end

  test "dojo.exercise.instructions" do
    name = 'Print_Diamond'
    exercise = @dojo.exercises[name]
    @paas.dir(exercise).spy_read('instructions','your task...')
    exercise = @dojo.exercises[name]
    assert_equal 'your task...', exercise.instructions
  end

end
