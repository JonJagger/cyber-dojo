#!/bin/bash ../test_wrapper.sh

require_relative './app_models_test_base'

class ExternalDouble
  def initialize(_dojo)
  end
end

class DojoTests < AppModelsTestBase

  #- - - - - - - - - - - - - - - - - - - - - - - - -
  # config classes and root-paths
  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'D51880',
  'runner can be set' do
    set_runner_class('ExternalDouble')
    assert_equal ExternalDouble, runner.class
  end

  test 'B0E7E4',
  'runner set to non-existant-class raises' do
    set_runner_class(does_not_exist)
    assert_raises(NameError) { runner.class }
  end

  test 'CE3ED1',
  'runner not present in config raises' do
    write_empty_config
    assert_raises(NameError) { runner.class }
  end

  # - - - - - -

  test 'F062B9',
  'disk can be set' do
    set_disk_class('ExternalDouble')
    assert_equal ExternalDouble, disk.class
  end

  test 'BB2F80',
  'disk set to non-existant-class raises' do
    set_disk_class(does_not_exist)
    assert_raises(NameError) { disk.class }
  end

  test '03849E',
  'disk not present in config raises' do
    write_empty_config
    assert_raises(NameError) { disk.class }
  end

  # - - - - - -

  test 'D45887',
  'shell can be set' do
    set_shell_class('ExternalDouble')
    assert_equal ExternalDouble, shell.class
  end

  test '3C8DAF',
  'shell set to non-existant-class raises' do
    set_shell_class(does_not_exist)
    assert_raises(NameError) { shell.class }
  end

  test '431F9A',
  'shell not present in config raises' do
    write_empty_config
    assert_raises(NameError) { shell.class }
  end

  # - - - - - -

  test 'A6C799',
  'git can be set' do
    set_git_class('ExternalDouble')
    assert_equal ExternalDouble, git.class
  end

  test '3BC12E',
  'git set to non-existant-class raises' do
    set_git_class(does_not_exist)
    assert_raises(NameError) { git.class }
  end

  test '4B5378',
  'git not present in config raises' do
    write_empty_config
    assert_raises(NameError) { git.class }
  end

  # - - - - - -

  test '87B411',
  'log can be set' do
    set_log_class('ExternalDouble')
    assert_equal ExternalDouble, log.class
  end

  test '4A413E',
  'log set to non-existant-class raises' do
    set_log_class(does_not_exist)
    assert_raises(NameError) { log.class }
  end

  test 'C24C96',
  'log not present in config raises' do
    write_empty_config
    assert_raises(NameError) { log.class }
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '209EA1',
  'exercises.path can be set' do
    set_exercises_root(path = '/fake_exercises_path/')
    assert_equal path, exercises.path
  end

  test '27A597',
  'languages.path can be set' do
    set_languages_root(path = '/fake_languages_path/')
    assert_equal path, languages.path
  end

  test '5C25B8',
  'caches.path can be set' do
    set_caches_root(path = '/fake_caches_path/')
    assert_equal path, dojo.caches.path
  end

  test 'B6CC06',
  'katas.path can be set' do
    set_katas_root(path = '/fake_katas_path/')
    assert_equal path, katas.path
  end

  test '01CD52',
  'paths always have trailing slash even if config value does not' do
    set_exercises_root(exercises_path = '/fake_exercises_path')
    set_languages_root(languages_path = '/fake_languages_path')
    set_katas_root(katas_path = '/fake_katas_path')
    set_caches_root(caches_path = '/fake_caches_path')

    assert_equal exercises_path + '/', exercises.path
    assert_equal languages_path + '/', languages.path
    assert_equal     katas_path + '/', katas.path
    assert_equal    caches_path + '/', caches.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -
  # TODO: Have no defaults
  # all settings must be
  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E4EA30',
  'exercises.path config default is root-dir/exercises/' do
    assert_equal dojo.root_dir + '/exercises/', exercises.path
  end

  test '5EEF16',
  'languages.path config default is root-dir/languages/' do
    assert_equal dojo.root_dir + '/languages/', languages.path
  end

  test '2AF58E',
  'caches.path default is root-dir/caches/' do
    assert_equal dojo.root_dir + '/caches/', caches.path
  end

  test 'CBFF2D',
  'katas.path config default is root-dir/katas/ but in test/app_models setup' +
    ' it is already reset because tests write to katas' do
    refute_equal dojo.root_dir + '/katas/', katas.path
  end

  #test '17909E',
  #'external runner object is DockerRunner' do  'StubRunner'
  #  assert_equal 'DockerRunner', runner.class.name
  #end

  test 'E640DD',
  'external git object is HostGit' do
    assert_equal HostGit, git.class
  end

  test '228760',
  'external disk object default is HostDisk' do
    assert_equal HostDisk, disk.class
  end

  test '511E3E',
  'external shell object default is HostShell' do
    assert_equal HostShell, shell.class
  end

  test '03170A',
  'external log object default is HostLog' do
    assert_equal HostLog, log.class
  end

  private

  def does_not_exist
    'DoesNotExist'
  end

  def write_empty_config
    IO.write(dojo.config_filename, "{}")
  end

end
