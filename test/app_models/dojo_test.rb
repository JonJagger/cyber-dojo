#!/bin/bash ../test_wrapper.sh

require_relative 'model_test_base'

class DojoTests < ModelTestBase

  test 'exercises' do
    path = 'fake_exercises_path/'
    set_exercises_root(path)
    assert_equal path, exercises.path
  end

  test 'languages' do
    path = 'fake_languages_path/'
    set_languages_root(path)    
    assert_equal path, languages.path
  end

  test 'katas' do
    path = 'fake_katas_path/'
    set_katas_root(path)    
    assert_equal path, katas.path
  end

  test 'runner' do
    set_runner_class(name = 'RunnerStub')
    assert_equal name, runner.class.name
  end
  
  test 'disk' do
    set_disk_class(name = 'DiskStub')
    assert_equal name, disk.class.name
  end
    
  test 'git' do
    set_git_class(name = 'GitSpy')
    assert_equal name, git.class.name
  end
  
end
