#!/bin/bash ../test_wrapper.sh

require_relative './app_models_test_base'

class ExternalDouble
  def initialize(_dojo, _path = nil)
  end
end

class DojoTests < AppModelsTestBase

  #- - - - - - - - - - - - - - - - - - - - - - - - -
  # config defaults
  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'AACE2A',
  'config/cyber-dojo.json defaults' do
    class_of = dojo.config['class']
    assert_equal 'DockerTmpRunner', class_of['runner']
    assert_equal 'HostShell',       class_of['shell']
    assert_equal 'HostDisk',        class_of['disk']
    assert_equal 'HostGit',         class_of['git']
    assert_equal 'HostLog',         class_of['log']
    root_of = dojo.config['root']
    assert_equal '/var/www/cyber-dojo/languages/', root_of['languages']
    assert_equal '/var/www/cyber-dojo/exercises/', root_of['exercises']
    assert_equal '/var/www/cyber-dojo/caches/',    root_of['caches']
    assert_equal '/var/www/cyber-dojo/katas/',     root_of['katas']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -
  # config classes
  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'D51880',
  'runner can be set to alternative class' do
    set_runner_class('ExternalDouble')
    assert_equal ExternalDouble, runner.class
  end

  test 'B0E7E4',
  'runner set to non-existant-class raises' do
    set_runner_class(does_not_exist)
    assert_raises(StandardError) { runner.class }
  end

  # - - - - - -

  test '4A9DEC',
  'katas can be set to alternative class' do
    set_katas_class('ExternalDouble')
    assert_equal ExternalDouble, katas.class
  end

  test '31FEC4',
  'katas set to non-existant-class raises' do
    set_katas_class(does_not_exist)
    assert_raises(StandardError) { katas.class }
  end

  # - - - - - -

  test 'D45887',
  'shell can be set to alternative class' do
    set_shell_class('ExternalDouble')
    assert_equal ExternalDouble, shell.class
  end

  test '3C8DAF',
  'shell set to non-existant-class raises' do
    set_shell_class(does_not_exist)
    assert_raises(StandardError) { shell.class }
  end

  # - - - - - -

  test 'F062B9',
  'disk can be set to alternative class' do
    set_disk_class('ExternalDouble')
    assert_equal ExternalDouble, disk.class
  end

  test 'BB2F80',
  'disk set to non-existant-class raises' do
    set_disk_class(does_not_exist)
    assert_raises(StandardError) { disk.class }
  end

  # - - - - - -

  test 'A6C799',
  'git can be set to alternative class' do
    set_git_class('ExternalDouble')
    assert_equal ExternalDouble, git.class
  end

  test '3BC12E',
  'git set to non-existant-class raises' do
    set_git_class(does_not_exist)
    assert_raises(StandardError) { git.class }
  end

  # - - - - - -

  test '87B411',
  'log can be set to alternative class' do
    set_log_class('ExternalDouble')
    assert_equal ExternalDouble, log.class
  end

  test '4A413E',
  'log set to non-existant-class raises' do
    set_log_class(does_not_exist)
    assert_raises(StandardError) { log.class }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -
  # config roots
  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test '209EA1',
  'exercises.path can be set to an alternative' do
    set_exercises_root(path = tmp_root + 'fake_exercises_path/')
    assert_equal path, exercises.path
  end

  test '27A597',
  'languages.path can be set to an alternative' do
    set_languages_root(path = tmp_root + 'fake_languages_path/')
    assert_equal path, languages.path
  end

  test '5C25B8',
  'caches.path can be set to an alternative' do
    set_caches_root(path = tmp_root + 'fake_caches_path/')
    assert_equal path, caches.path
  end

  test 'B6CC06',
  'katas.path can be set to an alternative' do
    set_katas_root(path = tmp_root + 'fake_katas_path/')
    assert_equal path, katas.path
  end

  test '01CD52',
  'paths always have trailing slash even when config value does not' do
    set_exercises_root(exercises_path = tmp_root + '/exercises')
    set_languages_root(languages_path = tmp_root + '/languages')
    set_katas_root(        katas_path = tmp_root + '/fake_katas_path')
    set_caches_root(      caches_path = tmp_root + '/fake_caches_path')

    assert_equal exercises_path + '/', exercises.path
    assert_equal languages_path + '/', languages.path
    assert_equal     katas_path + '/', katas.path
    assert_equal    caches_path + '/', caches.path
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  test 'CBFF2D',
  'katas.path is automatically overriden by test setup because tests write to katas' do
    default_path = dojo.config['root']['katas']
    refute_equal default_path + '/', katas.path
    refute_equal default_path,       katas.path
  end

  private

  def does_not_exist
    'DoesNotExist'
  end

end
