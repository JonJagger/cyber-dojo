#!/bin/bash ../test_wrapper.sh

require_relative './app_model_test_base'

class ExternalDouble
  def initialize(_dojo)
  end
end

class DojoTests < AppModelTestBase

  test 'E4EA30',
  'exercises path defaults to root-dir/exercises/' do
    assert_equal dojo.root_dir + '/exercises/', dojo.exercises.path
  end

  test '209EA1',
  'exercises path can be set via CYBER_DOJO_EXERCISES_ROOT environment variable' do
    path = '/fake_exercises_path/'
    set_exercises_root(path)
    assert_equal path, dojo.exercises.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test '5EEF16',
  'languages path defaults to root-dir/languages/' do
    assert_equal dojo.root_dir + '/languages/', dojo.languages.path
  end

  test '27A597',
  'languages path can be set via CYBER_DOJO_LANGUAGES_ROOT environment variable' do
    path = '/fake_languages_path/'
    set_languages_root(path)
    assert_equal path, dojo.languages.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'CBFF2D',
  'katas path defaults to root-dir/katas/ but in test/app_models setup' +
    ' it is already redirected because tests write to katas' do
    refute_equal dojo.root_dir + '/katas/', dojo.katas.path
  end

  test 'B6CC06',
  'katas path can be set via CYBER_DOJO_KATAS_ROOT environment variable' do
    path = '/fake_katas_path/'
    set_katas_root(path)
    assert_equal path, dojo.katas.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test '2AF58E',
  'caches path defaults to root-dir/caches/' do
    assert_equal dojo.root_dir + '/caches/', dojo.caches.path
  end

  test '5C25B8',
  'caches path can be set via CYBER_DOJO_CACHES_ROOT environment variable' do
    path = '/fake_caches_path/'
    set_caches_root(path)
    assert_equal path, dojo.caches.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test '01CD52',
  'path always has a trailing slash even if environment variable value does not' do

    path = '/fake_exercises_path'
    set_exercises_root(path)
    assert_equal path + '/', dojo.exercises.path

    path = '/fake_languages_path'
    set_languages_root(path)
    assert_equal path + '/', dojo.languages.path

    path = '/fake_katas_path'
    set_katas_root(path)
    assert_equal path + '/', dojo.katas.path

    path = '/fake_caches_path'
    set_caches_root(path)
    assert_equal path + '/', dojo.caches.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E640DD',
  'external git object defaults to HostGit' do
    unset('GIT')
    assert_equal 'HostGit', dojo.git.class.name
  end

  test 'A6C799',
  'external git object can be set via CYBER_DOJO_GIT_CLASS environment variable' do
    set_git_class('ExternalDouble')
    assert_equal 'ExternalDouble', dojo.git.class.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test '81CB08',
  'external runner object defaults to DockerMachineRunner if docker-machine is installed' do
    unset('RUNNER')
    unset('SHELL')
    set_shell_class('MockHostShell')
    shell.mock_exec(['docker-machine --version'], 'any', shell.success)
    assert_equal 'DockerMachineRunner', dojo.runner.class.name
    shell.teardown
  end

  test 'BFF893',
  'external runner object defaults to DockerRunner if' +
     'docker-machine is not installed and docker is installed' do
    unset('RUNNER')
    unset('SHELL')
    set_shell_class('MockHostShell')
    shell.mock_exec(['docker-machine --version'], 'any', shell_failure=42)
    shell.mock_exec(['docker --version'], 'any', shell.success)
    assert_equal 'DockerRunner', dojo.runner.class.name
    shell.teardown
  end

  test 'B97509',
  'external runner object defaults to HostRunner if' +
    'docker-machine is not installed and docker is not installed' do
    unset('RUNNER')
    unset('SHELL')
    set_shell_class('MockHostShell')
    shell.mock_exec(['docker-machine --version'], 'any', shell_failure=42)
    shell.mock_exec(['docker --version'], 'any', shell_failure=42)
    assert_equal 'HostRunner', dojo.runner.class.name
    shell.teardown
  end

  test 'D51880',
  'external runner can be set via CYBER_DOJO_RUNNER_CLASS environment variable' do
    set_runner_class('ExternalDouble')
    assert_equal 'ExternalDouble', dojo.runner.class.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test '228760',
  'external disk object defaults to HostDisk' do
    unset('DISK')
    assert_equal 'HostDisk', dojo.disk.class.name
  end

  test 'F062B9',
  'external disk can be set via CYBER_DOJO_DISK_CLASS environment variable' do
    set_disk_class('ExternalDouble')
    assert_equal 'ExternalDouble', dojo.disk.class.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test '511E3E',
  'external shell object defaults to HostShell' do
    unset('SHELL')
    assert_equal 'HostShell', dojo.shell.class.name
  end

  test 'D45887',
  'external shell can be set via CYBER_DOJO_SHELL_CLASS environment variable' do
    set_shell_class('ExternalDouble')
    assert_equal 'ExternalDouble', dojo.shell.class.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'C126CA',
  'external starter object defaults to HostDiskAvatarStarter' do
    unset('STARTER')
    assert_equal 'HostDiskAvatarStarter', dojo.starter.class.name
  end

  test 'F6D938',
  'external starter can be set via CYBER_DOJO_STARTER_CLASS environment variable' do
    set_starter_class('ExternalDouble')
    assert_equal 'ExternalDouble', dojo.starter.class.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test '03170A',
  'external log object defaults to HostLog' do
    unset('LOG')
    assert_equal 'HostLog', dojo.log.class.name
  end

  test '87B411',
  'external log can be set via CYBER_DOJO_LOG_CLASS environment variable' do
    set_log_class('ExternalDouble')
    assert_equal 'ExternalDouble', dojo.log.class.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E51003',
  'external one_self object defaults to OneSelfCurl' do
    unset('ONE_SELF')
    assert_equal 'OneSelfCurl', dojo.one_self.class.name
  end

  test 'BF6101',
  'external one_self can be set via CYBER_DOJO_ONE_SELF_CLASS environment variable' do
    set_one_self_class('ExternalDouble')
    assert_equal 'ExternalDouble', dojo.one_self.class.name
  end

  private

  def unset(key)
    cd_unset('CYBER_DOJO_' + key + '_CLASS')
  end

end
