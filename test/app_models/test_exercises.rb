#!/bin/bash ../test_wrapper.sh

require_relative './app_models_test_base'

class ExercisesTests < AppModelsTestBase

  test '14AD4C',
  'exercises path has correct basic format when set with trailing slash' do
    path = tmp_root + 'slashed/'
    set_exercises_root(path)
    assert_equal path, exercises.path
    assert correct_path_format?(exercises)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B09C99',
  'exercises path has correct basic format when set without trailing slash' do
    path = tmp_root + 'unslashed'
    set_exercises_root(path)
    assert_equal path + '/', exercises.path
    assert correct_path_format?(exercises)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '789739',
  'cache file exists' do
    assert disk[exercises.path].exists? exercises.cache_filename
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '71D327',
  'exercises[name] is nil if name is not an existing exercise' do
    assert_nil exercises['wibble_XXX']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'FC5958',
  'simple smoke test' do
    exercises_names = exercises.map(&:name).sort
    doors = '100_doors'
    assert exercises_names.size > 20
    assert exercises_names.include?(doors)
    assert exercises['100_doors'].instructions.start_with?('100 doors in a row')
  end

end
