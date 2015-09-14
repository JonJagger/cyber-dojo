#!/bin/bash ../test_wrapper.sh

require_relative 'model_test_base'

class DojoTests < ModelTestBase

  id['209EA1'].test\
  'exercises' do
    path = 'fake_exercises_path/'
    set_exercises_root(path)
    assert_equal path, exercises.path
  end

  id['27A597'].test\
  'languages' do
    path = 'fake_languages_path/'
    set_languages_root(path)    
    assert_equal path, languages.path
  end

  id['B6CC06'].test\
  'katas' do
    path = 'fake_katas_path/'
    set_katas_root(path)    
    assert_equal path, katas.path
  end

  id['055B3C'].test\
  'runner' do
    set_runner_class(name = 'RunnerStub')
    assert_equal name, runner.class.name
  end
  
  id['B9E496'].test\
  'disk' do
    set_disk_class(name = 'DiskStub')
    assert_equal name, disk.class.name
  end
    
  id['8874E9'].test\
  'git' do
    set_git_class(name = 'GitSpy')
    assert_equal name, git.class.name
  end
  
end
