#!/bin/bash ../test_wrapper.sh

require_relative './app_models_test_base'

class ExercisesTests < AppModelsTestBase

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
    assert_equal path + '/', exercises.path
    assert correct_path_format?(exercises)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'F027CB',
  'refresh_cache' do
    set_caches_root(tmp_root)
    exercises.refresh_cache
    exercises_names = exercises.map(&:name).sort
    doors = '100_doors'
    assert exercises_names.include?(doors)
    assert exercises['100_doors'].instructions.start_with?('100 doors in a row')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '3E277A',
  'no exercises when cache is empty' do
    set_caches_root(tmp_root)
    caches.write_json(cache_filename, {})
    assert_equal [], exercises.to_a
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '52110A',
  'execises from cache when cache is not empty' do
    set_caches_root(tmp_root)
    cache = {
      '100_doors'    => { instructions: doors_instructions = 'go here'  },
      'Bowling_Game' => { instructions: bowling_instructions = 'are here' }
    }
    caches.write_json(cache_filename, cache)
    exercises_names = exercises.map(&:name).sort
    assert_equal ['100_doors', 'Bowling_Game'], exercises_names, 'names'
    assert_equal doors_instructions, exercises['100_doors'].instructions, '100 doors'
    assert_equal bowling_instructions, exercises['Bowling_Game'].instructions, 'Bowling Game'
  end

  private

  def cache_filename
    Exercises.cache_filename
  end

end
