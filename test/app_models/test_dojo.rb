#!/bin/bash ../test_wrapper.sh

require_relative './app_model_test_base'

class DojoTests < AppModelTestBase

  test '209EA1',
  'exercises' do
    path = '/fake_exercises_path/'
    set_exercises_root(path)
    assert_equal path, dojo.exercises.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test '27A597',
  'languages' do
    path = '/fake_languages_path/'
    set_languages_root(path)
    assert_equal path, dojo.languages.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B6CC06',
  'katas' do
    path = '/fake_katas_path/'
    set_katas_root(path)
    assert_equal path, dojo.katas.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test '055B3C',
  'runner' do
    set_runner_class(name = 'RunnerStub')
    assert_equal name, dojo.runner.class.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B9E496',
  'disk' do
    set_disk_class(name = 'DiskStub')
    assert_equal name, dojo.disk.class.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test '8874E9',
  'git' do
    set_git_class(name = 'GitSpy')
    assert_equal name, dojo.git.class.name
  end

end
