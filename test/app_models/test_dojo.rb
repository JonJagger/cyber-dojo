#!/usr/bin/env ruby

require_relative 'model_test_base'

class DojoTests < ModelTestBase

  test 'exercises' do
    path = 'fake_exercises_path/'
    set_exercises_root(path)
    assert_equal path, dojo.exercises.path
  end

  test 'languages' do
    path = 'fake_languages_path/'
    set_languages_root(path)    
    assert_equal path, dojo.languages.path
  end

  test 'katas' do
    path = 'fake_katas_path/'
    set_katas_root(path)    
    assert_equal path, dojo.katas.path
  end

  test 'runner' do
    name = 'DockerTestRunner'
    set_runner_class_name(name)
    assert_equal name, dojo.runner.class.name
  end
  
  test 'disk' do
    name = 'Disk'
    set_disk_class_name(name)
    assert_equal name, dojo.disk.class.name
  end
    
  test 'git' do
    name = 'Git'
    set_git_class_name(name)
    assert_equal name, dojo.git.class.name
  end
  
  # - - - - - - - - - - - - - - - -
  
  def dojo
    Dojo.new
  end
  
end
