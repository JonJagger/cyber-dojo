#!/bin/bash ../test_wrapper.sh

require_relative './app_models_test_base'

class ExercisesTest < AppModelsTestBase

  prefix = '2DD'

  test prefix+'D4C',
  'exercises path has correct basic format when set with trailing slash' do
    path = tmp_root + '/' + 'folder'
    set_exercises_root(path + '/')
    assert_equal path, exercises.path
    assert correct_path_format?(exercises)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'C99',
  'exercises path has correct basic format when set without trailing slash' do
    path = tmp_root + '/' + 'folder'
    set_exercises_root(path)
    assert_equal path, exercises.path
    assert correct_path_format?(exercises)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'327',
  'exercises[name] is nil if name is not an existing exercise' do
    assert_nil exercises['wibble_XXX']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'D85',
  'exercise path has correct basic format' do
    exercise = exercises['Fizz_Buzz']
    assert exercise.path.match(exercise.name)
    assert correct_path_format?(exercise)
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test prefix+'EF3',
  'name is as set in ctor' do
    exercise = exercises[name = 'Fizz_Buzz']
    assert_equal name, exercise.name
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test prefix+'65F',
  'instructions are loaded from file of same name via the cache' do
    exercise = exercises['Fizz_Buzz']
    assert exercise.instructions.start_with? 'Write a program that prints'
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test prefix+'280',
  'instructions are loaded from file of same name directly' do
    exercise = Exercise.new(dojo.exercises, 'Fizz_Buzz')
    assert exercise.instructions.start_with? 'Write a program that prints'
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test prefix+'64B',
  'cache is created on demand' do
    # be very careful here... naming exercises will create exercises!
    path = exercises.cache_path
    filename = exercises.cache_filename
    assert disk[path].exists? filename
    old_cache = disk[path].read(filename)
    `rm #{path}/#{filename}`
    refute disk[path].exists? filename
    @dojo = nil  # force dojo.exercises to be new Exercises object
    exercises    # dojo.exercises ||= Exercises.new(...)
    assert disk[path].exists? filename
    new_cache = disk[path].read(filename)
    assert_equal old_cache, new_cache
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test prefix+'958',
  'simple smoke test' do
    exercises_names = exercises.map(&:name).sort
    doors = '100_doors'
    assert exercises_names.size > 20
    assert exercises_names.include?(doors)
    assert exercises['100_doors'].instructions.start_with?('100 doors in a row')
  end

end
