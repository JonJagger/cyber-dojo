#!/bin/bash ../test_wrapper.sh

require_relative 'model_test_base'

class ExercisesTests < ModelTestBase

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
  
  test 'refresh_cache' do
    set_disk_class('DiskFake')
    disk[exercises.path + '100 doors'].write('instructions', 'imagine there are 100 doors...')    
    exercises.refresh_cache
    exercises_names = exercises.map {|exercise| exercise.name }.sort
    assert_equal ['100 doors'], exercises_names
    assert_equal 'imagine there are 100 doors...', exercises['100 doors'].instructions
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'no exercises when cache is empty' do
    set_disk_class('DiskFake')
    exercises.dir.write('cache.json', cache={})    
    assert_equal [], exercises.to_a
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'execises from cache when cache is not empty' do
    cache = {
      '100 doors' => {
        :instructions => 'go here'
      },
      'Bowling Game' => {
        :instructions => 'are here' 
      }
    }
    exercises.dir.write('cache.json', cache)
    exercises_names = exercises.map {|exercise| exercise.name }.sort

    assert_equal ['100 doors', 'Bowling Game'], exercises_names, 'names'
    
    # exercises[name] does not use cache
    exercises['100 doors'].dir.write('instructions', 'XXX')
    exercises['Bowling Game'].dir.write('instructions', 'YYY')
    
    assert_equal 'XXX', exercises['100 doors'].instructions, '100 doors'
    assert_equal 'YYY', exercises['Bowling Game'].instructions, 'Bowling Game'
  end
    
end
