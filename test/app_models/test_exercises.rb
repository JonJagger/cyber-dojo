#!/usr/bin/env ruby

require_relative 'model_test_base'

class ExercisesTests < ModelTestBase

  def setup
    super
    assert_equal disk_class_name, "Disk"    
  end
  
  test "path is set from ENV" do
    path = 'end_with_slash/'
    set_exercises_path(path)
    assert_equal path, Exercises.new.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'path appends slash if necessary' do
    path = 'unslashed'
    set_exercises_path(path)
    assert_equal path + '/', Exercises.new.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test 'each() empty' do
    set_disk_class_name('DiskFake')
    assert_equal [], exercises.each.map {|exercise| exercise.name}    
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'each() gives all exercises which exist' do
    exercises_names = exercises.each.map {|exercise| exercise.name }
    ['Unsplice','Verbal','Fizz_Buzz'].each do |name|
      assert exercises_names.include? name
    end    
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'exercises[X] is exercise named X' do
    name = 'Print_Diamond'
    assert_equal name, exercises[name].name
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def exercises
    @dojo.exercises
  end
  
end
