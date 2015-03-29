#!/usr/bin/env ruby

require_relative 'model_test_base'

class ExercisesTests < ModelTestBase

  def setup
    super
    @root_dir = exercises_path
  end
  
  def teardown
    set_exercises_path(@root_dir)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'test caller has setup exercises-environment-variable' do
    assert_not_nil @root_dir
    assert File.directory? @root_dir
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "path is set from ENV['CYBER_DOJO_EXERCISES_ROOT'] " do
    set_exercises_path('end_with_slash/')
    assert_equal 'end_with_slash/', Exercises.new.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'path appends slash if necessary' do
    expected = 'unslashed'
    set_exercises_path(expected)
    assert_equal expected + '/', Exercises.new.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'each() gives all exercises which exist' do
    exercises_names = @dojo.exercises.each.map {|exercise| exercise.name }
    ['Unsplice','Verbal','Fizz_Buzz'].each do |name|
      assert exercises_names.include? name
    end
    
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'exercises[X] is exercise named X' do
    name = 'Print_Diamond'
    assert_equal name, @dojo.exercises[name].name
  end
  
end
