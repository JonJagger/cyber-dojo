__DIR__ = File.dirname(__FILE__)
require __DIR__ + '/../test_helper'
require __DIR__ + '/../app_models/spy_disk'
require __DIR__ + '/../app_models/stub_git'
require __DIR__ + '/../app_models/stub_runner'

class LinuxPaasExercisesTests < ActionController::TestCase

  def setup
    @disk = SpyDisk.new
    @git = StubGit.new
    @runner = StubRunner.new
    @paas = LinuxPaas.new(@disk, @git, @runner)
    @format = 'rb'
    @dojo = @paas.create_dojo(root_path + '../../', @format)
  end

  def teardown
    @disk.teardown
  end

  #- - - - - - - - - - - - - - - - - - - - -

  test "dojo.exercises.each() forwards to paas.exercises_each()" do
    exercises = @dojo.exercises.map {|exercise| exercise.name}
    assert exercises.include? 'Unsplice'
    assert exercises.include? 'Verbal'
    assert exercises.include? 'Yatzy'
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
