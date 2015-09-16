#!/bin/bash ../test_wrapper.sh

require_relative 'AppModelTestBase'

class DojoTests < AppModelTestBase

  test '209EA1',
  'exercises' do
    path = 'fake_exercises_path/'
    set_exercises_root(path)
    assert_equal path, exercises.path
  end

  test '27A597',
  'languages' do
    path = 'fake_languages_path/'
    set_languages_root(path)    
    assert_equal path, languages.path
  end

  test 'B6CC06',
  'katas' do
    path = 'fake_katas_path/'
    set_katas_root(path)    
    assert_equal path, katas.path
  end

  test '055B3C',
  'runner' do
    set_runner_class(name = 'RunnerStub')
    assert_equal name, runner.class.name
  end
  
  test 'B9E496',
  'disk' do
    set_disk_class(name = 'DiskStub')
    assert_equal name, disk.class.name
  end
    
  test '8874E9',
  'git' do
    set_git_class(name = 'GitSpy')
    assert_equal name, git.class.name
  end
  
end
