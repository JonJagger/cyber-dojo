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

  test '789739',
  'cache is automatically created on demand' do
    set_caches_root(tmp_root)

    refute caches.exists?(cache_filename)
    exercises_names = exercises.map(&:name).sort
    assert caches.exists?(cache_filename)

    doors = '100_doors'
    assert exercises_names.include?(doors)
    assert exercises['100_doors'].instructions.start_with?('100 doors in a row')

  end

  private

  def cache_filename
    'exercises_cache.json'
  end

end
