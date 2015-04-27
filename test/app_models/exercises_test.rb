#!/usr/bin/env ../test_wrapper.sh app/models

require_relative 'model_test_base'

class ExercisesTests < ModelTestBase

  def setup
    super
    assert_equal get_disk_class_name, 'Disk'
    set_runner_class_name('DummyTestRunner')
  end
  
  test 'path is set from ENV' do
    path = 'end_with_slash/'
    set_exercises_root(path)
    assert_equal path, exercises.path
    assert path_ends_in_slash?(exercises)
    assert path_has_no_adjacent_separators?(exercises)    
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'path is forced to end in a slash' do
    path = 'unslashed'
    set_exercises_root(path)
    assert_equal path+'/', exercises.path
    assert path_ends_in_slash?(exercises)
    assert path_has_no_adjacent_separators?(exercises)    
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
  
end
