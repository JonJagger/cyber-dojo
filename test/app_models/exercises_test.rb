#!/bin/bash ../test_wrapper.sh

require_relative 'AppModelTestBase'

class ExercisesTests < AppModelTestBase

  test '14AD4C',
  'exercises path has correct basic format when set with trailing slash' do
    path = 'slashed/'
    set_exercises_root(path)
    assert_equal path, exercises.path
    assert correct_path_format?(exercises)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B09C99',
  'exercises path has correct basic format when set without trailing slash' do
    path = 'unslashed'
    set_exercises_root(path)
    assert_equal path+'/', exercises.path
    assert correct_path_format?(exercises)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test 'F027CB',
  'refresh_cache' do
    set_disk_class('DiskFake')
    disk[exercises.path + '100 doors'].write('instructions', 'imagine there are 100 doors...')    
    exercises.refresh_cache
    exercises_names = exercises.map {|exercise| exercise.name }.sort
    assert_equal ['100 doors'], exercises_names
    assert_equal 'imagine there are 100 doors...', exercises['100 doors'].instructions
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '3E277A',
  'no exercises when cache is empty' do
    set_disk_class('DiskFake')
    exercises.dir.write('cache.json', cache={})    
    assert_equal [], exercises.to_a
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '52110A',
  'execises from cache when cache is not empty' do
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
