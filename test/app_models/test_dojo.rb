#!/bin/bash ../test_wrapper.sh

require_relative './app_models_test_base'

class ExternalDouble
  def initialize(_dojo)
  end
end

class DojoTests < AppModelsTestBase

  #- - - - - - - - - - - - - - - - - - - - - - - - -
  # config-root paths
  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E4EA30',
  'exercises.path config default is root-dir/exercises/' do
    assert_equal dojo.root_dir + '/exercises/', exercises.path
  end

  test '209EA1',
  'exercises path can be set for testing' do
    path = '/fake_exercises_path/'
    set_exercises_root(path)
    assert_equal path, exercises.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test '5EEF16',
  'languages.path config default is root-dir/languages/' do
    assert_equal dojo.root_dir + '/languages/', languages.path
  end

  test '27A597',
  'languages path can be set for testing' do
    path = '/fake_languages_path/'
    set_languages_root(path)
    assert_equal path, languages.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'CBFF2D',
  'katas.path config default is root-dir/katas/ but in test/app_models setup' +
    ' it is already reset because tests write to katas' do
    refute_equal dojo.root_dir + '/katas/', katas.path
  end

  test 'B6CC06',
  'katas.path can be set for testing' do
    path = '/fake_katas_path/'
    set_katas_root(path)
    assert_equal path, katas.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test '2AF58E',
  'caches.path default is root-dir/caches/' do
    assert_equal dojo.root_dir + '/caches/', caches.path
  end

  test '5C25B8',
  'caches.path can be set for testing' do
    path = '/fake_caches_path/'
    set_caches_root(path)
    assert_equal path, dojo.caches.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test '01CD52',
  'path always has a trailing slash even if config value does not' do
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
  # config-class
  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E640DD',
  'external git object is HostGit' do
    assert_equal 'HostGit', git.class.name
  end

  test 'A6C799',
  'external git object can be set for testing' do
    set_git_class('ExternalDouble')
    assert_equal 'ExternalDouble', git.class.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  #test '17909E',
  #'external runner object is DockerRunner' do  'StubRunner'
  #  assert_equal 'DockerRunner', runner.class.name
  #end

  test 'D51880',
  'external runner can be set for testing' do
    set_runner_class('ExternalDouble')
    assert_equal 'ExternalDouble', runner.class.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test '228760',
  'external disk object default is HostDisk' do
    assert_equal 'HostDisk', disk.class.name
  end

  test 'F062B9',
  'external disk can be set for testing' do
    set_disk_class('ExternalDouble')
    assert_equal 'ExternalDouble', disk.class.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test '511E3E',
  'external shell object default is HostShell' do
    assert_equal 'HostShell', shell.class.name
  end

  test 'D45887',
  'external shell can be set for testing' do
    set_shell_class('ExternalDouble')
    assert_equal 'ExternalDouble', shell.class.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test '03170A',
  'external log object default is to HostLog' do
    assert_equal 'HostLog', log.class.name
  end

  test '87B411',
  'external log can be set for testing' do
    set_log_class('ExternalDouble')
    assert_equal 'ExternalDouble', log.class.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  private

=begin
    test '81CB08',
    'external runner object default is to DockerRunner' do
       'if docker-machine is installed and its cache exists' do
      #unset('RUNNER')
      #unset('SHELL')
      set_shell_class('MockHostShell')
      shell.mock_exec(['docker-machine --version'], 'any', shell.success)
      set_caches_root(tmp_root + 'caches')
      dir = disk[caches.path]
      dir.make
      dir.write('docker_machine_runner_cache.json', 'any')
      assert_equal 'DockerMachineRunner', dojo.runner.class.name
      shell.teardown
    end

    test 'BFF893',
    'external runner object defaults to DockerRunner ' +
       'if docker-machine is not installed and ' +
       'docker is installed and its cache exists' do
      unset('RUNNER')
      unset('SHELL')
      set_shell_class('MockHostShell')
      shell.mock_exec(['docker-machine --version'], 'any', shell_failure=42)
      shell.mock_exec(['docker --version'], 'any', shell.success)
      set_caches_root(tmp_root + 'caches')
      dir = disk[caches.path]
      dir.make
      dir.write('docker_runner_cache.json', 'any')
      assert_equal 'DockerRunner', dojo.runner.class.name
      shell.teardown
    end
=end

end
