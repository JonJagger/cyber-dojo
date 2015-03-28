#!/usr/bin/env ruby

require_relative 'model_test_base'

class ExercisesTests < ModelTestBase

  def env_var
    'CYBER_DOJO_EXERCISES_ROOT'
  end
  
  def setup
    super
    @root_dir = ENV[env_var]
  end
  
  def teardown
    ENV[env_var] = @root_dir  
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'test caller has setup exercises-environment-variable' do
    assert_not_nil @root_dir
    assert File.directory? @root_dir
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "path is set from ENV['CYBER_DOJO_EXERCISES_ROOT'] " do
    ENV[env_var] = 'end_with_slash/'
    assert_equal 'end_with_slash/', Exercises.new.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'path appends slash if necessary' do
    ENV[env_var] = 'unslashed'
    assert_equal 'unslashed/', Exercises.new.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'each() gives all exercises which exist' do
    exercises_names = @dojo.exercises.each.map {|exercise| exercise.name }
    ['Unsplice','Verbal'].each do |name|
      assert exercises_names.include? name
    end
    
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'exercises[name] gives access to exercise with given name' do
    name = 'Print_Diamond'
    assert_equal name, @dojo.exercises[name].name
  end
  
end
